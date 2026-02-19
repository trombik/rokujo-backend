require "rails_helper"

RSpec.describe Article, type: :model do
  let(:source) { create(:article, uuid: "uuid-source", url: "url-source") }
  let(:article) { create(:article, uuid: "uuid-article", url: "url-article") }
  let(:article_hash) do
    {
      uuid: "uuid",
      sources: nil
    }
  end
  let(:source_hash) do
    {
      uuid: "source_uuid"
    }
  end

  let(:sentence_hash) do
    {
      text: "Text",
      meta: {
        line_number: 1
      }
    }
  end

  describe "associattion" do
    it { is_expected.to have_many :sentences }
  end

  describe "validation" do
    subject { build(:article) }

    it { is_expected.to validate_presence_of :uuid }
    it { is_expected.to validate_uniqueness_of :uuid }
  end

  describe "#replace_sentences_with_hash" do
    it "replaces sentences" do
      expect do
        article.replace_sentences_with_hash([sentence_hash])
        article.save!
      end.to change { article.sentences.count }.by(1)
    end

    context "when hash is empty" do
      it "deletes sentences" do
        article.sentences << create(:sentence, article_uuid: article.uuid)
        article.save!

        expect do
          article.replace_sentences_with_hash([])
          article.save!
        end.to change { article.sentences.count }.by(-1)
      end
    end
  end

  describe "#replace_sources_from_hash" do
    context "when given hash is empty" do
      it "deletes existing sources" do
        article.sources << source
        article.save!

        expect do
          article.replace_sources_from_hash([])
          article.save!
        end.to change { article.sources.count }.by(-1)
      end
    end

    context "when a souce is given" do
      it "adds the source to sources" do
        expect do
          article.replace_sources_from_hash([source_hash])
          article.save!
        end.to change { article.sources.count }.by(1)
      end
    end
  end

  describe ".import_from_hash" do
    it "does not rise" do
      expect do
        described_class.import_from_hash!(article_hash)
      end.not_to raise_error
    end

    it "creates an article from a hash" do
      expect do
        described_class.import_from_hash!(article_hash)
      end.to change(described_class, :count).by(1)
    end

    context "when article has a source" do
      before do
        article_hash["sources"] = [source_hash]
      end

      it "creates an article and a source article" do
        expect do
          described_class.import_from_hash!(article_hash)
        end.to change(described_class, :count).by(2)
      end

      specify "the article references the source through souces" do
        article = described_class.import_from_hash!(article_hash)

        expect(article.sources.first.uuid).to eq source_hash[:uuid]
      end
    end

    context "when an article with the same uuid already exists" do
      it "does not create a new article but reuses the existing one" do
        create(:article, uuid: article_hash[:uuid])

        expect do
          described_class.import_from_hash!(article_hash)
        end.not_to change(described_class, :count)
      end
    end
  end

  describe "scopes" do
    before do
      1.upto(3) do |n|
        create(:article, url: "https://example#{n}.org/", site_name: n.to_s)
      end
    end

    describe ".site_names_like" do
      context "when a word matches an article", :aggregate_failures do
        it "returns the article" do
          articles = described_class.site_names_like("1")
          expect(articles.map(&:site_name)).to include("1")
          expect(articles.count).to eq 1
        end
      end

      context "when words is empty string" do
        it "returns all" do
          articles = described_class.site_names_like("")
          expect(articles).to eq described_class.all
        end
      end

      context "when words includes empty string and nil" do
        it "ignores empty string and nil" do
          articles = described_class.site_names_like(["1", "", nil])
          expect(articles.map(&:site_name)).to contain_exactly("1")
        end
      end

      context "when one keyword matches an article and another does not match anything at all" do
        it "returns the matched article only" do
          articles = described_class.site_names_like(%w[1 foo])
          expect(articles.map(&:site_name)).to contain_exactly("1")
        end
      end

      context "when keywords is an empty array" do
        it "returns all" do
          expect(described_class.site_names_like([])).to eq(described_class.all)
        end
      end

      context "when nil is given" do
        it "returns all" do
          expect(described_class.site_names_like(nil)).to eq(described_class.all)
        end
      end
    end

    describe ".url_like" do
      context "when word matches an Article" do
        it "returns the matched article", :aggregate_failures do
          articles = described_class.url_like("example1")
          expect(articles.map(&:url)).to include("https://example1.org/")
          expect(articles.count).to eq 1
        end
      end

      context "when word is empty string" do
        it "returns all" do
          expect(described_class.url_like("").count).to eq(3)
        end
      end
    end

    describe ".urls_like" do
      context "when words is an array of keywords" do
        it "returns articles that matches any of keywords", :aggregate_failures do
          articles = described_class.urls_like(%w[example1 example2])
          urls = articles.map(&:url)
          expect(urls).to include("https://example1.org/", "https://example2.org/")
          expect(urls).not_to include("https://example3.org/")
        end
      end

      context "when words includes empty string and nil" do
        it "ignores empty string and nil" do
          articles = described_class.urls_like(["example1", "", nil])
          expect(articles.map(&:url)).to contain_exactly("https://example1.org/")
        end
      end

      context "when one keyword matches an article and another does not match anything at all" do
        it "returns the matched article only" do
          articles = described_class.urls_like(%w[example1 nonexistent])
          expect(articles.map(&:url)).to contain_exactly("https://example1.org/")
        end
      end

      context "when keywords is an empty array" do
        it "returns all" do
          expect(described_class.urls_like([])).to eq(described_class.all)
        end
      end

      context "when nil is given" do
        it "returns all" do
          expect(described_class.urls_like(nil)).to eq(described_class.all)
        end
      end
    end
  end
end

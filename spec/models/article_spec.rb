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
      # rubocop:disable RSpec/ExampleLength
      it "deletes sentences" do
        article.sentences << create(:sentence, article_uuid: article.uuid)
        article.save!

        expect do
          article.replace_sentences_with_hash([])
          article.save!
        end.to change { article.sentences.count }.by(-1)
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  describe "#replace_sources_from_hash" do
    context "when given hash is empty" do
      # rubocop:disable RSpec/ExampleLength
      it "deletes existing sources" do
        article.sources << source
        article.save!

        expect do
          article.replace_sources_from_hash([])
          article.save!
        end.to change { article.sources.count }.by(-1)
      end
      # rubocop:enable RSpec/ExampleLength
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
end

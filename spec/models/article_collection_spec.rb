require "rails_helper"

RSpec.describe ArticleCollection, type: :model do
  let(:collection) { create(:article_collection, name: "Name", key: "site_name", value: "Site 1") }

  before do
    create(:article, site_name: "Site 1", url: "http://example.org/foo")
    create(:article, site_name: "Site 1", url: "http://example.org/bar")
    create(:article, site_name: "Site 2", url: "http://example.net/")
  end

  describe "validation" do
    it { is_expected.to validate_presence_of :key }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_inclusion_of(:key).in_array(%w[site_name normalized_url]) }
  end

  describe "assertion" do
    it { is_expected.to have_many :article_collection_taggings }
    it { is_expected.to have_many :collection_tags }
  end

  describe "#articles" do
    it "returns correct number of articles" do
      expect(collection.articles.size).to eq 2
    end

    specify "the site_name of artciles matches the value" do
      expect(collection.articles.pluck(:site_name).uniq).to eq [collection.value]
    end

    context "when key is normalized_url" do
      let(:collection) { described_class.new(key: "normalized_url", value: "example.org/") }

      it "returns correct number of articles" do
        expect(collection.articles.size).to eq 2
      end

      specify "the normalized_urls of results start with the value" do
        expect(collection.articles.pluck(:normalized_url)).to all(start_with(collection.value))
      end
    end

    context "when key is a full path of an article" do
      let(:collection) { described_class.new(key: "normalized_url", value: "example.org/foo") }

      it "returns the matched article only" do
        expect(collection.articles.pluck(:normalized_url)).to eq [collection.value]
      end
    end

    context "when value for normalized_url contains `%`" do
      let(:collection) { described_class.new(key: "normalized_url", value: "example%") }

      it "escapes the `%` in the value and returns nothing" do
        expect(collection.articles.size).to eq 0
      end
    end
  end

  describe "#include_article?" do
    context "when an article belongs to the collection" do
      it "returns true" do
        article = create(:article, site_name: "Site 1")

        expect(collection.include_article?(article)).to be true
      end
    end

    context "when an article does not belong to the collection" do
      it "returns false" do
        article = create(:article, site_name: "Site X")

        expect(collection.include_article?(article)).to be false
      end
    end
  end

  describe "#invalidate_cache" do
    before do
      allow(Rails.cache).to receive(:fetch).and_call_original
    end

    it "forces include_article? to re-fetch data" do
      article = create(:article, site_name: "Site 1")
      collection.include_article?(article)
      collection.invalidate_cache
      collection.include_article?(article)

      expect(Rails.cache).to have_received(:fetch).with(/uuids/, any_args).twice
    end
  end

  describe ".matches_for" do
    it "returns all ArticleCollection that match the given article" do
      article = create(:article, site_name: "Site 1")
      collection

      expect(described_class.matches_for(article)).to include collection
    end
  end

  describe ".valid_keys" do
    it "returns an array of valid keys as String" do
      expect(described_class.valid_keys).to all(be_a String)
    end

    specify "the keys contain only attributes that exist in the Article model" do
      article_columns = Article.column_names

      expect(described_class.valid_keys).to all(be_in(article_columns))
    end
  end
end

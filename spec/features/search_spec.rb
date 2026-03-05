require "rails_helper"

TARGET_WORD = "Ruby".freeze
TARGET_TAG = "ruby".freeze
TARGET_SITE_NAME = "Site 1".freeze
TARGET_NORMALIZED_URL = "example.org/path".freeze

RSpec.describe "Search features", type: :feature do
  let(:article) { create(:article, site_name: TARGET_SITE_NAME) }
  let!(:target_sentence) do
    create(:sentence, article: article, text: "Hello #{TARGET_WORD}")
  end

  let(:operators) { {} }

  describe "regexp search word" do
    it "finds the target sentence" do
      results = Sentence.search_with_operators("Rub[Yy]", operators)

      expect(results).to include(target_sentence)
    end
  end

  describe "tag operator" do
    let(:operators) { { tags: [TARGET_TAG] } }

    before do
      tag_ruby = create(:collection_tag, name: TARGET_TAG)
      create(:article_collection, key: "site_name", value: TARGET_SITE_NAME, collection_tags: [tag_ruby])
    end

    it "finds the target sentence" do
      results = Sentence.search_with_operators(TARGET_WORD, operators)

      expect(results).to include(target_sentence)
    end

    context "when the word is a regexp" do
      it "finds the target sentence" do
        results = Sentence.search_with_operators("Rub[Yy]", operators)

        expect(results).to include(target_sentence)
      end
    end

    context "when the word matches multiple sentences in a tagged article" do
      it "finds all the sentences" do
        create(:sentence, article: article, text: "#{TARGET_WORD} is great.")
        results = Sentence.search_with_operators(TARGET_WORD, operators)

        expect(results.count).to eq 2
      end
    end

    context "when the word matches sentences in different tagged articles" do
      it "finds all the sentences" do
        another_article = create(:article, site_name: TARGET_SITE_NAME)
        create(:sentence, article: another_article, text: "#{TARGET_WORD} is great.")
        results = Sentence.search_with_operators(TARGET_WORD, operators)

        expect(results.count).to eq 2
      end
    end

    context "when the word matches sentences in a tagged article and another untagged article" do
      it "finds one in the tagged article" do
        untagged_article = create(:article, site_name: "Site X")
        create(:sentence, article: untagged_article, text: "#{TARGET_WORD} is great.")
        results = Sentence.search_with_operators(TARGET_WORD, operators)

        expect(results).to contain_exactly(target_sentence)
      end
    end
  end

  describe "site_name operator" do
    context "when searching by site_name" do
      let(:operators) { { site_names: [TARGET_SITE_NAME] } }

      it "finds the sentence with matching site_name" do
        results = Sentence.search_with_operators(TARGET_WORD, operators)
        expect(results).to include(target_sentence)
      end

      it "does not find sentences from other sites" do
        other_article = create(:article, site_name: "Other Site")
        other_sentence = create(:sentence, article: other_article, text: TARGET_WORD)

        results = Sentence.search_with_operators(TARGET_WORD, operators)
        expect(results).not_to include(other_sentence)
      end
    end
  end
end

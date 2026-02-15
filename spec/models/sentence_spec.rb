require "rails_helper"

RSpec.describe Sentence, type: :model do
  describe "associattion" do
    it { is_expected.to belong_to :article }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of :line_number }
    it { is_expected.to validate_presence_of :text }
  end

  describe ".match" do
    it "returns sentences that match a regexp" do
      sentences = [build(:sentence, text: "foobar"), build(:sentence, text: "foobbar")]
      create(:article, sentences: sentences)

      expect(described_class.match("foob{2}").count).to eq 1
    end

    it "ignores case by default" do
      sentences = [build(:sentence, text: "Foobar"), build(:sentence, text: "Foobbar")]
      create(:article, sentences: sentences)

      expect(described_class.match("foob{2}").count).to eq 1
    end
  end

  describe ".like" do
    it "returns sentences that contain a word" do
      sentences = [build(:sentence, text: "foobar"), build(:sentence, text: "foo")]
      create(:article, sentences: sentences)

      expect(described_class.like("foo").count).to eq 2
    end
  end

  describe ".context_sentences" do
    it "returns sentences around the target sentence" do
      article = create(:article)
      article.sentences = create_list(:sentence, 10, article: article)
      article.save!
      target_sentence = article.sentences[article.sentences.count / 2]

      expect(described_class.context_sentences(target_sentence, 1).count).to eq 3
    end
  end
end

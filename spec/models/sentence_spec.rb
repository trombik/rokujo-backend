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

  describe "#analyze_and_store_pos!" do
    let(:article) { create(:article) }
    let(:sentence) { create(:sentence, article: article, text: "私は本を読む。") }
    let(:mock_model) { instance_double(Spacy::Language) }

    let(:tokens) do
      # rubocop:disable RSpec/VerifiedDoubles
      head = double(Spacy::Token, text: "読む", pos: "VERB")
      # rubocop:enable RSpec/VerifiedDoubles
      allow(head).to receive(:i).and_return(0)

      [
        { text: "私", lemma: "私", pos: "PRON", tag: "名詞-代名詞", head: head, dep: "nsubj" },
        { text: "は", lemma: "は", pos: "ADP", tag: "助詞-係助詞", head: head, dep: "case" },
        { text: "本", lemma: "本", pos: "NOUN", tag: "名詞-一般", head: head, dep: "obj" },
        { text: "を", lemma: "を", pos: "ADP", tag: "助詞-格助詞", head: head, dep: "case" },
        { text: "読む", lemma: "読む", pos: "VERB", tag: "動詞-一般", head: head, dep: "ROOT" }
      ]
    end

    before do
      mock_doc = tokens.map do |t|
        # rubocop:disable RSpec/VerifiedDoubles
        d = double(Spacy::Token, t)
        # rubocop:enable RSpec/VerifiedDoubles
        allow(d).to receive_messages(i: 0, morph: "", idx: 0)
        d
      end
      allow(mock_model).to receive(:read).and_return(mock_doc)
    end

    it "stores TokenAnalysis" do
      expect { sentence.analyze_and_store_pos!(mock_model) }.to change(TokenAnalysis, :count).by(5)
    end
  end
end

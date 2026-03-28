require "rails_helper"

RSpec.describe Sentence, type: :model do
  describe "associattion" do
    it { is_expected.to belong_to :article }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of :line_number }
    it { is_expected.to validate_presence_of :text }
  end

  describe "scope" do
    describe ".like" do
      it "returns sentences that contain a word" do
        sentences = [build(:sentence, text: "foobar"), build(:sentence, text: "foo")]
        create(:article, sentences: sentences)

        expect(described_class.like("foo").count).to eq 2
      end
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

    describe ".by_site_name" do
      it "returns a limited scope by site_name", :aggregate_failures do
        article = create(:article, site_name: "foo")
        sentence = create(:sentence, article: article)
        create(:sentence, article: create(:article, site_name: "bar"))

        expect(described_class.by_site_name("foo")).to contain_exactly(sentence)
      end
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
    let(:sentence) { create(:sentence, article: article, text: "私は本を読む。", analyze: false) }

    it "stores TokenAnalysis" do
      analysis_results = [
        { i: 0, text: "私", lemma: "私", pos: "PRON", tag: "代名詞", dep: "nsubj", head: 4,
          morph: "Reading=ワタクシ", idx: 0 },
        { i: 1, text: "は", lemma: "は", pos: "ADP", tag: "助詞-係助詞", dep: "case", head: 0,
          morph: "Reading=ハ", idx: 1 },
        { i: 2, text: "本", lemma: "本", pos: "NOUN", tag: "名詞-普通名詞-一般", dep: "obj", head: 4,
          morph: "Reading=ホン", idx: 2 },
        { i: 3, text: "を", lemma: "を", pos: "ADP", tag: "助詞-格助詞", dep: "case", head: 2,
          morph: "Reading=ヲ", idx: 3 },
        { i: 4, text: "読む", lemma: "読む", pos: "VERB", tag: "動詞-一般", dep: "ROOT", head: 4,
          morph: "Inflection=五段-マ行;終止形-一般|Reading=ヨム", idx: 4 },
        { i: 5, text: "。", lemma: "。", pos: "PUNCT", tag: "補助記号-句点", dep: "punct", head: 4,
          morph: "Reading=。", idx: 6 }
      ].map(&:stringify_keys)
      allow(TextAnalysisService).to receive(:call).and_return(analysis_results)

      expect do
        sentence.analyze_and_store_pos!
      end.to change(TokenAnalysis, :count).by(analysis_results.size)
    end

    it "reloads the instance" do
      sentence.analyze_and_store_pos!
      expect(sentence.token_analyses).not_to be_empty
    end
  end

  describe ".analysis_ratio" do
    it "calcurate the ratio" do
      article = create(:article)
      # create two sentences
      sentence = create(:sentence, article: article, analyze: false)
      create(:sentence, article: article, analyze: false)

      # create token_analysis for one sentence but not the other
      create_list(:token_analysis, 6, sentence: sentence)

      expect(described_class.analysis_ratio).to eq 0.5
    end

    context "when the count of sentences is zero" do
      it "returns zero" do
        expect(described_class.analysis_ratio).to eq 0
      end
    end
  end

  describe ".tokens_per_sentence" do
    it "returns tokens per sentence" do
      article = create(:article)
      sentence = create(:sentence, article: article, analyze: false)
      create_list(:token_analysis, 6, sentence: sentence)

      expect(described_class.tokens_per_sentence).to eq 6
    end

    context "when the number of sentence is zero" do
      it "returns zero" do
        expect(described_class.tokens_per_sentence).to eq 0
      end
    end
  end

  describe ".search_with_operators" do
    # XXX more tests can be found in features/search_spec.rb
    it "finds sentences associated with specific collection tags" do
      article = create(:article, site_name: "Site 1")
      create(:article_collection, key: "site_name",
                                  value: "Site 1",
                                  collection_tags: [
                                    create(:collection_tag, name: "ruby")
                                  ])
      target_sentence = create(:sentence, article: article, text: "Hello Ruby")

      results = described_class.search_with_operators("Ruby", { tags: ["ruby"] })

      expect(results).to contain_exactly(target_sentence)
    end
  end
end

require "rails_helper"

RSpec.describe AnalyzeTokensJob, type: :job do
  let(:article) { create(:article) }
  let(:sentence) { create(:sentence, text: "こんにちは。", article: article) }
  let(:args) { [sentence.article_uuid, sentence.line_number] }
  let(:mocked_results) do
    [
      {
        "i" => 0,
        "text" => "こんにちは",
        "lemma" => "こんにちは",
        "pos" => "INTJ",
        "tag" => "感動詞-一般",
        "dep" => "ROOT",
        "head" => 0,
        "morph" => "Reading=コンニチハ",
        "idx" => 0
      },
      {
        "i" => 1,
        "text" => "。",
        "lemma" => "。",
        "pos" => "PUNCT",
        "tag" => "補助記号-句点",
        "dep" => "punct",
        "head" => 0,
        "morph" => "Reading=。",
        "idx" => 5
      }
    ]
  end

  before do
    allow(TextAnalysisService).to receive(:call).and_return(mocked_results)
  end

  it "creates token_analyses records", :aggregate_failures do
    expect do
      described_class.perform_now(args)
    end.to change(TokenAnalysis, :count).by_at_least(1)

    expect(sentence.token_analyses.first.text).to eq "こんにちは"
  end

  it "is idempotent" do
    described_class.perform_now(args)

    expect do
      described_class.perform_now([sentence.article_uuid, sentence.line_number])
    end.not_to change(TokenAnalysis, :count)
  end

  context "when the API server is not available" do
    before do
      allow(TextAnalysisService).to receive(:call).and_raise described_class::TextAnalysisServiceNotAvailavleError
    end

    it "retries the job" do
      expect do
        described_class.perform_now(args)
      end.to have_enqueued_job(described_class).with(args).exactly(:once)
    end
  end

  context "when the sentence the job references does not eixst" do
    before do
      allow(TextAnalysisService).to receive(:call).and_raise described_class::SentenceNotFoundError
    end

    it "discards the job" do
      expect do
        described_class.perform_now(args)
      end.not_to have_enqueued_job(described_class)
    end
  end
end

require "rails_helper"

RSpec.describe AnalyzeTokensJob, type: :job do
  let(:sentence) { create(:sentence, text: "こんにちは。") }

  it "creates token_analyses records", :aggregate_failures do
    mocked_results = [
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
    allow(TextAnalysisService).to receive(:call).and_return(mocked_results)

    expect do
      described_class.perform_now(sentence.id)
    end.to change(TokenAnalysis, :count).by_at_least(1)

    expect(sentence.token_analyses.first.text).to be_present
  end

  it "is idempotent" do
    described_class.perform_now(sentence.id)

    expect do
      described_class.perform_now(sentence.id)
    end.not_to change(TokenAnalysis, :count)
  end
end

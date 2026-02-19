require "rails_helper"

RSpec.describe AnalyzeTokensJob, type: :job do
  let(:sentence) { create(:sentence, text: "こんにちは。") }

  it "creates token_analyses records", :aggregate_failures do
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

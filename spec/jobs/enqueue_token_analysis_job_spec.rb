require "rails_helper"

RSpec.describe EnqueueTokenAnalysisJob, type: :job do
  include ActiveJob::TestHelper

  let!(:sentence_without_tokens) { create(:sentence) }
  let!(:sentence_with_tokens) { create(:sentence) }

  before do
    create(:token_analysis, sentence: sentence_with_tokens)
  end

  it "enqueues AnalyzeTokensJob for sentences missing tokens" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(AnalyzeTokensJob).with([sentence_without_tokens.article_uuid,
                                                     sentence_without_tokens.line_number])
  end

  it "does not enqueue job for sentences that already have tokens" do
    expect do
      described_class.perform_now
    end.not_to have_enqueued_job(AnalyzeTokensJob).with([sentence_with_tokens.article_uuid,
                                                         sentence_with_tokens.line_number])
  end
end

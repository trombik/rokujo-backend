require "rails_helper"

RSpec.describe "TokenAnalysisManagers", type: :request do
  describe "POST /token_analysis_manager/start" do
    it "enqueues EnqueueTokenAnalysisJob and returns :created", :aggregate_failures do
      expect do
        post start_token_analysis_manager_path
      end.to have_enqueued_job(EnqueueTokenAnalysisJob)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /token_analysis_manager/stop" do
    before do
      AnalyzeTokensJob.perform_later(1)
      AnalyzeTokensJob.perform_later(2)
    end

    it "deletes pending jobs", :aggregate_failures do
      post stop_token_analysis_manager_path

      expect(SolidQueue::Job.where(class_name: "AnalyzeTokensJob").count).to eq(0)
      expect(Rails.cache.read("stop_analysis_enqueue")).to be true
      expect(response).to have_http_status(:success)
    end
  end
end

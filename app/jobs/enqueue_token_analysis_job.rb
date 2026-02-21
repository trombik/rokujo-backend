# A job to enqueue AnalyzeTokensJob in batches
class EnqueueTokenAnalysisJob < ApplicationJob
  limits_concurrency to: 1, key: -> { "enqueue_token_analysis" }, duration: 5.minutes

  def perform
    Rails.cache.delete("stop_analysis_enqueue")
    sentences = Sentence.where.missing(:token_analyses).distinct
    sentences.in_batches(of: 200) do |relation|
      break if Rails.cache.read("stop_analysis_enqueue")

      jobs = relation.pluck(:id).map { |id| AnalyzeTokensJob.new(id) }
      ActiveJob.perform_all_later(jobs)
      sleep 0.1
    end
  end
end

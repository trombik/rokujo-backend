# A job to enqueue AnalyzeTokensJob in batches
class EnqueueTokenAnalysisJob < ApplicationJob
  limits_concurrency to: 1, key: -> { "enqueue_token_analysis" }, duration: 5.minutes

  def perform
    Sentence.where.missing(:token_analyses)
            .distinct
            .find_each do |sentence|
              AnalyzeTokensJob.perform_later(sentence.id)
            end
  end
end

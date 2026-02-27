# A job to enqueue AnalyzeTokensJob in batches
class EnqueueTokenAnalysisJob < ApplicationJob
  limits_concurrency to: 1, key: -> { "enqueue_token_analysis" }, duration: 5.minutes

  def perform
    Rails.cache.delete("stop_analysis_enqueue")
    sentences = Sentence.where.missing(:token_analyses).distinct
    sentences.each do |sentence|
      break if Rails.cache.read("stop_analysis_enqueue")

      job = AnalyzeTokensJob.new([sentence.article_uuid, sentence.line_number])
      ActiveJob.perform_all_later(job)
    end
  end
end

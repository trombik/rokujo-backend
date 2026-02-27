# A job to analyze a sentence
class AnalyzeTokensJob < ApplicationJob
  queue_as :analysis
  limits_concurrency to: 1, key: ->(sentence_id) { sentence_id }

  def perform(keys)
    article_uuid, line_number = keys
    sentence = Sentence.find_by(article_uuid: article_uuid, line_number: line_number)
    return unless sentence

    sentence.analyze_and_store_pos!
  end
end

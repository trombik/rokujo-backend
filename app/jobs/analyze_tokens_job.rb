# A job to analyze a sentence
class AnalyzeTokensJob < ApplicationJob
  queue_as :analysis
  limits_concurrency to: 1, key: ->(sentence_id) { sentence_id }

  def perform(sentence_id)
    sentence = Sentence.find_by(id: sentence_id)
    return unless sentence

    sentence.analyze_and_store_pos!
  end
end

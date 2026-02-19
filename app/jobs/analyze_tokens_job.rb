# A job to analyze a sentence
class AnalyzeTokensJob < ApplicationJob
  queue_as :analysis
  limits_concurrency to: 1, key: ->(sentence_id) { sentence_id }, duration: 5.minutes

  def self.model
    @model ||= Spacy::Language.new("ja_ginza")
  end

  def perform(sentence_id)
    sentence = Sentence.find_by(id: sentence_id)
    return unless sentence
    return if sentence.token_analyses.exists?

    sentence.analyze_and_store_pos!(self.class.model)
  end
end

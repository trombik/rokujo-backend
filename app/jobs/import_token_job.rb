# import tokens
class ImportTokenJob < ApplicationJob
  queue_as :default
  class Error < StandardError; end
  class SentenceNotFoundError < Error; end

  retry_on SQLite3::BusyException

  def perform(article_uuid:, line_number:, tokens:)
    sentence = Sentence.find_by(article_uuid: article_uuid, line_number: line_number)
    raise SentenceNotFoundError unless sentence

    sentence.transaction do
      sentence.token_analyses.destroy_all
      tokens.each do |t|
        sentence.token_analyses.build(t)
      end
      sentence.save!
    end
  end
end

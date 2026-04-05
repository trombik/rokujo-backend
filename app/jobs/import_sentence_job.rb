# Import a sentence
class ImportSentenceJob < ApplicationJob
  queue_as :default

  retry_on SQLite3::BusyException

  def perform(article_uuid:, line_number:, text:, tokens:)
    sentence = Sentence.build(article_uuid: article_uuid,
                              line_number: line_number,
                              text: text)
    sentence.save!
    ImportTokenJob.perform_later(article_uuid: article_uuid, line_number: line_number, tokens: tokens)
  end
end

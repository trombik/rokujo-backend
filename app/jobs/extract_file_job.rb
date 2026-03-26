# Job to extract sentences from a file
class ExtractFileJob < ApplicationJob
  include NotificationHelper

  queue_as :analysis

  MINUTES = 60

  def perform(file, extractor)
    extractor = extractor.constantize.new(file, widget_enable: false)
    Timeout.timeout(15 * MINUTES) do
      extractor.extract_sentences
    end
    hash = serialize_hash(extractor.item.to_h)
    ImportArticleJob.perform_later(hash)
    broadcast_toast(title: self.class.name, message: "Enqueued ImportArticleJob")
  ensure
    # do not remove fixture files
    FileUtils.rm file unless Rails.env.test?
  end

  private

  def serialize_hash(hash)
    hash[:url] = hash[:url].to_s
    hash.delete(:filename) # unsupported by DB scheme
    hash.delete(:source) # unsupported by DB scheme
    hash
  end
end

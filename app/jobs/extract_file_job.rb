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
    # remove the file as all the sentences are passed to another job and the
    # the file is no longer necessary.  but do not remove fixture files during
    # the test.
    FileUtils.rm file unless Rails.env.test?
    broadcast_toast(title: self.class.name, message: "Enqueued ImportArticleJob")
  end

  private

  def serialize_hash(hash)
    hash[:url] = hash[:url].to_s
    hash.delete(:filename) # unsupported by DB scheme
    hash.delete(:source) # unsupported by DB scheme
    hash
  end
end

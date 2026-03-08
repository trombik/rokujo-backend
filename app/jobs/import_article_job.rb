# Job to import an article as a hash
class ImportArticleJob < ApplicationJob
  class EnqueueError < StandardError; end

  queue_as :default

  rescue_from(Exception) do |exception|
    Rails.error.report(exception)
    raise exception
  end

  # @param hash [Hash] Hashed article.
  def perform(hash)
    article = Article.import_from_hash!(hash)
    article.sentences.each do |sentence|
      keys = [sentence.article_uuid, sentence.line_number]
      begin
        AnalyzeTokensJob.perform_later(keys)
      rescue StandardError => e
        raise EnqueueError, "Failed to enqueue AnalyzeTokensJob. cause: #{e}"
      end
    end
  end
end

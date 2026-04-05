# Job to import an article as a hash. The job imports an article and enqueuea
# multiple AnalyzeTokensJob for its sentences.
class ImportArticleJob < ApplicationJob
  class Error < StandardError; end
  class MissingSentencesError < Error; end
  class MissingTokensError < Error; end

  queue_as :default

  # discard if the article is a duplicated article
  discard_on ActiveRecord::RecordNotUnique

  retry_on SQLite3::BusyException

  # @param hash [Hash] Hashed article.
  def perform(hash)
    validate_hash!(hash)
    Article.import_from_hash!(hash)
    return if hash["lang"] != "ja"

    hash["sentences"].each.with_index do |sentence, index|
      tokens = hash["tokens"][index]
      ImportSentenceJob.perform_later(article_uuid: hash["uuid"],
                                      line_number: index,
                                      text: sentence,
                                      tokens: tokens)
    end
  end

  private

  def validate_hash!(hash)
    raise MissingSentencesError if hash["sentences"].blank?
    raise MissingTokensError if hash["tokens"].blank?
    raise ActiveRecord::RecordNotUnique if Article.find_by(normalized_url: NormalizeUrlService.call(hash["url"]))
  end
end

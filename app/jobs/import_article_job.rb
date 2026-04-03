# Job to import an article as a hash. The job imports an article and enqueuea
# multiple AnalyzeTokensJob for its sentences.
class ImportArticleJob < ApplicationJob
  queue_as :default

  # discard if the article is a duplicated article
  discard_on ActiveRecord::RecordNotUnique, report: true

  # @param hash [Hash] Hashed article.
  def perform(hash)
    Article.import_from_hash!(hash)
  end
end

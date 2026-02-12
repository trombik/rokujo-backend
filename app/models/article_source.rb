# a bridge model for Article and sources
class ArticleSource < ApplicationRecord
  belongs_to :article, inverse_of: :article_sources
  belongs_to :source_article, class_name: "Article", inverse_of: :reversed_article_sources
end

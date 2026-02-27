# A collection of articles
class ArticleCollection < ApplicationRecord
  has_many :articles, dependent: :nullify
  has_many :article_collection_taggings, dependent: :destroy
  has_many :collection_tags, through: :article_collection_taggings

  validates :key, presence: true
  validates :name, presence: true
end

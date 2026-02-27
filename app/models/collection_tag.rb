# Tags for ArticleCollection
class CollectionTag < ApplicationRecord
  has_many :article_collection_taggings, dependent: :destroy
  has_many :article_collections, through: :article_collection_taggings
  validates :name, presence: true, uniqueness: true
end

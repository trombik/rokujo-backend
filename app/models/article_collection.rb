# A collection of articles
class ArticleCollection < ApplicationRecord
  VALID_KEYS = %w[site_name normalized_url].freeze

  has_many :articles, dependent: :nullify
  has_many :article_collection_taggings, dependent: :destroy
  has_many :collection_tags, through: :article_collection_taggings

  validates :key, presence: true, inclusion: { in: VALID_KEYS }
  validates :name, presence: true, uniqueness: true
  validates :value, presence: true

  def associated_articles
    Article.where(key => value)
  end

  def self.valid_keys
    VALID_KEYS
  end
end

# This class represents a "Dynamic Collection" of articles.
#
# Unlike standard ActiveRecord associations that rely on foreign keys in a
# join table, this class determines membership dynamically based on shared
# attributes (e.g., `site_name`) or pattern matching (e.g., `normalized_url`).
#
# Why not a standard association? Standard `has_many` associations require
# static mapping in the database. In our use case, collection criteria can
# change or be based on URL patterns, making a hard-coded join table difficult
# to maintain. By using dynamic queries, we allow articles to "belong" to
# collections automatically as soon as they meet the criteria.
#
# ### Supported Keys (`VALID_KEYS`)
#
# Each key defines a different strategy for gathering articles:
#
# 1. `site_name` (Exact Match)
# 1. `normalized_url` (Prefix Match)
#
# We use prefix matching (`LIKE 'value%'`) for URLs to support hierarchical
# collections. This allows a single {ArticleCollection} to automatically
# include all sub-pages of a specific domain or directory without manual
# entry of every individual URL. It also remains highly performant by
# leveraging B-Tree indexes on the `normalized_url` column.
#
# ### Caching
#
# Since {#articles} is a custom method rather than a built-in association,
# it cannot be preloaded using `.includes`. To prevent N+1 queries when checking
# article membership across multiple collections:
#
# 1. We fetch all matching UUIDs for a collection and convert them into a `Set`.
# 2. This `Set` is cached via `Rails.cache` using `{cache_key_with_version}`.
# 3. Membership checks ({#include_article?}) are performed in-memory at O(1) speed.
#
# When an {Article} is created or updated, the cache for affected collections
# must be invalidated (typically via `touch` on the collection) to ensure
# the UUID set remains accurate.
#
class ArticleCollection < ApplicationRecord
  CACHE_EXPIRES_IN = 1.hour

  # An array of valid keys.
  VALID_KEYS = %w[site_name normalized_url].freeze

  has_many :article_collection_taggings, dependent: :destroy
  has_many :collection_tags, through: :article_collection_taggings

  validates :key, presence: true, inclusion: { in: VALID_KEYS }
  validates :name, presence: true, uniqueness: true
  validates :value, presence: true

  # Returns an array of Article associated with this ArticleCollection
  #
  # @return [ActiveRecord::Relation<Article>]
  def articles
    case key
    when "site_name"
      Article.where(key => value)
    when "normalized_url"
      Article.where("#{key} LIKE ?", "#{self.class.sanitize_sql_like(value)}%")
    else
      Article.none
    end
  end

  # Returns true if the given article belongs to this collection.
  # @param article [Article]
  # @return [Boolean]
  def include_article?(article)
    return false unless article

    uuids.include?(article.uuid)
  end

  # Invalidates the cached UUID set by updating the timestamp.
  #
  # This forces the {uuids} method to re-fetch data on the next call.
  def invalidate_cache
    return unless persisted?

    # rubocop:disable Rails/SkipsModelValidations
    #
    # `touch` skips validations but here, we use it to indirectly invalidate
    # Rails.cache to prevent cache stampedes, letting the cache store (like
    # Redis) handle the cleanup of old keys.
    touch
    # rubocop:enable Rails/SkipsModelValidations
  end

  # Returns all ArticleCollections that match the given article.
  # @param article [Article]
  # @return [Array<ArticleCollection>]
  def self.matches_for(article)
    all.select { |ac| ac.include_article?(article) }
  end

  # Returns array of ArticleCollection that covers normalized_url.
  #
  # @param normalized_url [String] Normalized URL. Use NormalizeUrlService to generate a normalized_url from a URL.
  # @return [Array<ArticleCollection>]
  def self.covering_collections(normalized_url)
    return [] if normalized_url.blank?

    where(key: "normalized_url").select { |el| normalized_url.start_with?(el.value) }
  end

  def self.valid_keys
    VALID_KEYS
  end

  # Class method to invalidate all collection caches at once.
  #
  # Useful for bulk data updates or maintenance.
  def self.invalidate_all_caches
    # rubocop:disable Rails/SkipsModelValidations
    touch_all
    # rubocop:enable Rails/SkipsModelValidations
  end

  private

  # Returns an array of cached article UUIDs associated with this ArticleCollection.
  #
  # @return [Set<String>]
  def uuids
    cache_key = "#{cache_key_with_version}/uuids"
    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRES_IN) do
      Rails.logger.debug { "[Cache Miss] Fetching UUIDs for #{self.class.name}: #{key} => #{value}" }
      articles.pluck(:uuid).to_set
    end
  end
end

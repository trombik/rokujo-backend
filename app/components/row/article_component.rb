# frozen_string_literal: true

# Row to display an article
class Row::ArticleComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(article:)
    @article = article
    super()
  end

  attr_reader :article

  def render?
    article.present?
  end

  private

  def domain
    Addressable::URI.parse(article.url).host
  rescue StandardError
    nil
  end

  def site_name
    article.site_name || t(".unknown_site_name")
  end

  def title
    article.title || ""
  end

  def source?
    article.sources.present?
  end

  def display_year
    time = article.modified_time || article.published_time || article.acquired_time
    time&.year
  end

  def description?
    article.description.present?
  end

  def truncated_description
    helpers.truncate(article.description, length: 120)
  end

  def truncated_title
    helpers.truncate(article.title, length: 40)
  end

  def article_collection_by_site_name
    return ArticleCollection.none if article.site_name.blank?

    ArticleCollection.find_by(key: "site_name", value: article.site_name)
  end

  def article_collections_by_normalized_urls
    return ArticleCollection.none if article.normalized_url.blank?

    ArticleCollection.covering_collections(article.normalized_url)
  end

  def uniq_key
    article.uuid
  end
end

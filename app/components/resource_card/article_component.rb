# frozen_string_literal: true

# A resource card for Article
class ResourceCard::ArticleComponent < ViewComponent::Base
  attr_reader :article

  def initialize(article)
    @article = article
    super()
  end

  private

  def domain
    URI.parse(article.url).host
  rescue StandardError
    nil
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
    helpers.truncate(article.title, length: 50)
  end
end

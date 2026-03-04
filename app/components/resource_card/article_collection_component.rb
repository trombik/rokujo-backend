# frozen_string_literal: true

# A card for ArticleCollection
class ResourceCard::ArticleCollectionComponent < ViewComponent::Base
  attr_reader :article_collection

  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end

  private

  def articles_link
    articles_article_collection_path(article_collection)
  end

  def key_badge_class
    case article_collection.key
    when "site_name"
      "bg-info-subtle text-info-emphasis"
    when "normalized_url"
      "bg-warning-subtle text-warning-emphasis"
    else
      "bg-error-subtle text-warning-emphasis"
    end
  end
end

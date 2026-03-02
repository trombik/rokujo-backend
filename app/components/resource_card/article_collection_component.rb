# frozen_string_literal: true

# A card for ArticleCollection
class ResourceCard::ArticleCollectionComponent < ViewComponent::Base
  attr_reader :article_collection

  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end
end

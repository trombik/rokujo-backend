# frozen_string_literal: true

# Form for ArticleCollection
class Forms::ArticleCollectionComponent < ViewComponent::Base
  attr_reader :article_collection

  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end
end

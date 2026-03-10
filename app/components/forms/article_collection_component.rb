# frozen_string_literal: true

# Form for ArticleCollection
class Forms::ArticleCollectionComponent < ViewComponent::Base
  attr_reader :article_collection

  def initialize(article_collection = nil)
    @article_collection = article_collection || ArticleCollection.new(name: "", key: "site_name", value: "")
    super()
  end
end

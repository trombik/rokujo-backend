# frozen_string_literal: true

class Forms::CollectionTagSelectorComponentPreview < ViewComponent::Preview
  def default
    collection = ArticleCollection.first
    render Forms::CollectionTagSelectorComponent.new(collection)
  end
end

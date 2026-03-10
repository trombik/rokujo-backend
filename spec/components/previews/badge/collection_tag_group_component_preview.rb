# frozen_string_literal: true

class Badge::CollectionTagGroupComponentPreview < ViewComponent::Preview
  def default
    collection = ArticleCollection.first
    render Badge::CollectionTagGroupComponent.new(collection)
  end
end

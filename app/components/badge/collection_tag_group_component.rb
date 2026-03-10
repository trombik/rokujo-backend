# frozen_string_literal: true

# Renders a group of Badge::CollectionTagGroupComponent from a collection.
class Badge::CollectionTagGroupComponent < ViewComponent::Base
  attr_reader :collection

  # @param collection [ArticleCollection]
  def initialize(collection)
    @collection = collection
    super()
  end

  def render?
    collection.present?
  end
end

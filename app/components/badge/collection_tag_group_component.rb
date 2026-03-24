# frozen_string_literal: true

# Renders a group of Badge::CollectionTagGroupComponent from a collection.
class Badge::CollectionTagGroupComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  # @param collection [ArticleCollection]
  def initialize(collection)
    @collection = collection
    super()
  end

  def render?
    collection.present?
  end

  private

  attr_reader :collection

  def uniq_key
    collection&.id || super
  end
end

# frozen_string_literal: true

# A row to show a tag with tagged collections.
class Row::TagComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(collection_tag)
    @collection_tag = collection_tag
    super()
  end

  private

  attr_reader :collection_tag

  def collections
    collection_tag.article_collections
  end

  def uniq_key
    tag.id
  end
end

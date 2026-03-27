# frozen_string_literal: true

class Row::TagComponentPreview < ViewComponent::Preview
  def default
    tag = CollectionTag.first
    render Row::TagComponent.new(tag)
  end
end

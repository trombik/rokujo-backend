# frozen_string_literal: true

class Badge::CollectionTagComponentPreview < ViewComponent::Preview
  def default
    resource = CollectionTag.first || FactoryBot.build(:collection_tag, name: "Tag")
    render Badge::CollectionTagComponent.new(resource)
  end
end

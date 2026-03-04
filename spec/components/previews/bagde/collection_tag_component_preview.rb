# frozen_string_literal: true

class Bagde::CollectionTagComponentPreview < ViewComponent::Preview
  def default
    resource = CollectionTag.first || FactoryBot.build(:collection_tag, name: "Tag")
    render Bagde::CollectionTagComponent.new(resource)
  end
end

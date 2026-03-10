# frozen_string_literal: true

class Badge::BaseComponentPreview < ViewComponent::Preview
  # @!group
  def default
    resource = FactoryBot.build(:collection_tag, name: "A tag")
    render Badge::BaseComponent.new(resource)
  end

  def without_link
    resource = FactoryBot.build(:collection_tag, name: "Anouthe tag")
    render Badge::BaseComponent.new(resource, link: false)
  end

  def japanese
    resource = FactoryBot.build(:collection_tag, name: "日本語")
    render Badge::BaseComponent.new(resource)
  end
  # @!endgroup
end

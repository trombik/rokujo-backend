# frozen_string_literal: true

class Bagde::BaseComponentPreview < ViewComponent::Preview
  # @!group
  def default
    resource = FactoryBot.build(:collection_tag, name: "A tag")
    render Bagde::BaseComponent.new(resource)
  end

  def without_link
    resource = FactoryBot.build(:collection_tag, name: "Anouthe tag")
    render Bagde::BaseComponent.new(resource, link: false)
  end

  def japanese
    resource = FactoryBot.build(:collection_tag, name: "日本語")
    render Bagde::BaseComponent.new(resource)
  end
  # @!endgroup
end

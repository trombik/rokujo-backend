# frozen_string_literal: true

class Forms::ValidationErrorComponentPreview < ViewComponent::Preview
  def default
    resource = FactoryBot.build(:site_name_correction, name: nil)
    resource.save
    render Forms::ValidationErrorComponent.new(resource)
  end
end

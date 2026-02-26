# frozen_string_literal: true

class Forms::SiteNameCorrectionsComponentPreview < ViewComponent::Preview
  def default
    resource = FactoryBot.build(:site_name_correction)
    render Forms::SiteNameCorrectionsComponent.new(resource)
  end
end

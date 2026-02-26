# frozen_string_literal: true

class ResourceCard::SiteNameCorrectionComponentPreview < ViewComponent::Preview
  def default
    resource = SiteNameCorrection.first
    render ResourceCard::SiteNameCorrectionComponent.new(resource)
  end
end

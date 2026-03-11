# frozen_string_literal: true

class Forms::SiteDeleteButtonComponentPreview < ViewComponent::Preview
  def default
    site_name = "foo"
    render Forms::SiteDeleteButtonComponent.new(site_name)
  end
end

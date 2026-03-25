# frozen_string_literal: true

class Shared::PageTitleComponentPreview < ViewComponent::Preview
  def default
    render Shared::PageTitleComponent.new(title: "Page title")
  end
end

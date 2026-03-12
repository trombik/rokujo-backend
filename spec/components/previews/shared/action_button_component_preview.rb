# frozen_string_literal: true

class Shared::ActionButtonComponentPreview < ViewComponent::Preview
  # @!group
  def default
    text = "Copy"
    icon = "copy"
    render Shared::ActionButtonComponent.new(text: text, icon: icon)
  end

  def text_only
    text = "UUID"
    render Shared::ActionButtonComponent.new(text: text)
  end

  def icon_only
    icon = "copy"
    render Shared::ActionButtonComponent.new(icon: icon)
  end
  # @!endgroup
end

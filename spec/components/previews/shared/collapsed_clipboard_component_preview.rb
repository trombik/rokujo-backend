# frozen_string_literal: true

class Shared::CollapsedClipboardComponentPreview < ViewComponent::Preview
  def default
    value = SecureRandom.hex
    label = "Random value"
    icon = "shuffle"
    render Shared::CollapsedClipboardComponent.new(label: label, value: value, icon: icon)
  end
end

# frozen_string_literal: true

class IconComponentPreview < ViewComponent::Preview
  def default
    render IconComponent.new("arrow-right", klass: "text-muted fs-5")
  end
end

# frozen_string_literal: true

class Navigation::BarComponentPreview < ViewComponent::Preview
  def default
    render(Navigation::BarComponent.new)
  end
end

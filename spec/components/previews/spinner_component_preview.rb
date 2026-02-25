# frozen_string_literal: true

class SpinnerComponentPreview < ViewComponent::Preview
  def default
    render(SpinnerComponent.new)
  end
end

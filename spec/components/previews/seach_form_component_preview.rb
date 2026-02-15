# frozen_string_literal: true

class SeachFormComponentPreview < ViewComponent::Preview
  def default
    render(SeachFormComponent.new)
  end
end

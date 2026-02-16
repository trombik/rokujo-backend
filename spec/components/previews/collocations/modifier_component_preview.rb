# frozen_string_literal: true

class Collocations::ModifierComponentPreview < ViewComponent::Preview
  def default
    render(Collocations::ModifierComponent.new)
  end
end

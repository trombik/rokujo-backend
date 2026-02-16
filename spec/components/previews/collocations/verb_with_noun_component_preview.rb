# frozen_string_literal: true

class Collocations::VerbWithNounComponentPreview < ViewComponent::Preview
  def default
    render(Collocations::VerbWithNounComponent.new)
  end
end

# frozen_string_literal: true

class Stats::CardComponentPreview < ViewComponent::Preview
  def default
    render(Stats::CardComponent.new)
  end
end

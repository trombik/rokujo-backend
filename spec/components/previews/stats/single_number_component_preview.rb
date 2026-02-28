# frozen_string_literal: true

class Stats::SingleNumberComponentPreview < ViewComponent::Preview
  def default
    render(Stats::SingleNumberComponent.new)
  end
end

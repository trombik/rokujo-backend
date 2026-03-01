# frozen_string_literal: true

class Stats::SentencesBySitenameComponentPreview < ViewComponent::Preview
  def default
    render(Stats::SentencesBySitenameComponent.new)
  end
end

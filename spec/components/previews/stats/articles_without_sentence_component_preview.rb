# frozen_string_literal: true

class Stats::ArticlesWithoutSentenceComponentPreview < ViewComponent::Preview
  def default
    render Stats::ArticlesWithoutSentenceComponent.new(100)
  end
end

# frozen_string_literal: true

class Stats::TokensPerSentenceComponentPreview < ViewComponent::Preview
  def default
    render Stats::TokensPerSentenceComponent.new(10_000)
  end

  def frame
    render Stats::TokensPerSentenceComponent.new
  end
end

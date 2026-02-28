# frozen_string_literal: true

class Stats::SentenceAnalysisRatioComponentPreview < ViewComponent::Preview
  def default
    render Stats::SentenceAnalysisRatioComponent.new(99.54)
  end

  def frame
    render Stats::SentenceAnalysisRatioComponent.new
  end
end

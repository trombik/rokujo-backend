# frozen_string_literal: true

class Stats::TotalTokenAnalysesComponentPreview < ViewComponent::Preview
  def default
    render Stats::TotalTokenAnalysesComponent.new(1001)
  end

  def frame
    render Stats::TotalTokenAnalysesComponent.new
  end
end

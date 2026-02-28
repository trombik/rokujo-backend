# frozen_string_literal: true

class Stats::TotalSentencesComponentPreview < ViewComponent::Preview
  # @!group
  def default
    render Stats::TotalSentencesComponent.new(10_000)
  end

  def big_number
    render Stats::TotalSentencesComponent.new(10_000_000_000)
  end

  def zero
    render Stats::TotalSentencesComponent.new(0)
  end

  def one
    render Stats::TotalSentencesComponent.new(1)
  end

  def negative
    render Stats::TotalSentencesComponent.new(-1)
  end

  def float
    render Stats::TotalArticlesComponent.new(1.2345)
  end
  # @!endgroup

  def frame
    render Stats::TotalSentencesComponent.new
  end
end

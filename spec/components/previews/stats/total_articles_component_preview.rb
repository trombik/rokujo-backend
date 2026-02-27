# frozen_string_literal: true

class Stats::TotalArticlesComponentPreview < ViewComponent::Preview
  # @!group
  def default
    render Stats::TotalArticlesComponent.new(10_000)
  end

  def big_number
    render Stats::TotalArticlesComponent.new(10_000_000_000)
  end

  def zero
    render Stats::TotalArticlesComponent.new(0)
  end

  def one
    render Stats::TotalArticlesComponent.new(1)
  end

  def negative
    render Stats::TotalArticlesComponent.new(-1)
  end
  # @!endgroup

  def frame
    render Stats::TotalArticlesComponent.new
  end
end

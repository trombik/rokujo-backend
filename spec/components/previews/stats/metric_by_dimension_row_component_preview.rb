# frozen_string_literal: true

class Stats::MetricByDimensionRowComponentPreview < ViewComponent::Preview
  def default
    render(Stats::MetricByDimensionRowComponent.new(label: "foo", value: 10_000, total: 10_000))
  end
end

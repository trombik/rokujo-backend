# frozen_string_literal: true

class Stats::MetricByDimensionComponentPreview < ViewComponent::Preview
  def default
    data = [
      { label: "google.com", value: 1200 },
      { label: "github.com", value: 800 },
      { label: "example.jp", value: 300 }
    ]
    total = 2300
    render Stats::MetricByDimensionComponent.new(id: "foo", metric: "件数", dimension: "サイト名") do |c|
      data.each do |item|
        c.with_row(label: item[:label], value: item[:value], total: total)
      end
    end
  end
end

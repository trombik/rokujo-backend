# frozen_string_literal: true

# A component to display metrics by a dimension, such as articles by site name
class Stats::MetricByDimensionComponent < ViewComponent::Base
  renders_many :rows, Stats::MetricByDimensionRowComponent

  attr_reader :id, :metric, :dimension, :title, :total

  def initialize(id:, metric:, dimension:, total: 0, title: nil)
    @id = id
    @metric = metric
    @dimension = dimension
    @title = title
    @total = total
    super()
  end

  def title_text
    title || "#{dimension} - #{metric}".upcase_first
  end
end

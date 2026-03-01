# frozen_string_literal: true

# The row component for Stats::MetricByDimensionComponent
class Stats::MetricByDimensionRowComponent < ViewComponent::Base
  attr_reader :label, :value, :total

  include ActiveSupport::NumberHelper

  def initialize(label:, value:, total: 0)
    @label = label
    @value = value
    @total = total
    super()
  end

  def label_text
    label
  end

  def value_text
    case value
    when Integer, Float
      number_to_delimited(value)
    when nil
      "NaN"
    else
      value.to_s
    end
  end

  def percent_text
    return "" unless numeric_value? && total
    return "" if total.zero?

    percentage = value.to_f / total * 100
    format("(%0.1f%%)", percentage)
  end

  def numeric_value?
    value.is_a? Numeric
  end
end

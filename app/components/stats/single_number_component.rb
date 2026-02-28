# frozen_string_literal: true

# A base class for a Stats component that simply displays a single number
class Stats::SingleNumberComponent < ViewComponent::Base
  attr_reader :data

  include ActiveSupport::NumberHelper

  def initialize(data = nil, frame_url: nil)
    @data = data
    @frame_url = frame_url
    super()
  end

  def frame_url
    raise NotImplementedError
  end

  def frame_id
    self.class.name.underscore.gsub("/", "_")
  end

  def title
    t(".title")
  end

  def data_text
    return "?" if data.nil?

    number_to_human(data).length <= number_to_delimited(data).length ? number_to_human(data) : number_to_delimited(data)
  rescue StandardError
    "NaN"
  end

  def unit_text
    return "?" if data.nil?

    t(".unit", count: data)
  end
end

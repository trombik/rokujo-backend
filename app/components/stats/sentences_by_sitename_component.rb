# frozen_string_literal: true

# Displays sentence counts by site_name
class Stats::SentencesBySitenameComponent < ViewComponent::Base
  attr_reader :data, :total

  def initialize(data = nil, frame_url: nil, total: nil)
    @data = data
    @frame_url = frame_url
    @total = total
    super()
  end

  def id
    self.class.name.underscore.gsub("/", "_")
  end

  def frame_id
    "frame_#{id}"
  end

  def frame_url
    @frame_url || stats_sentences_by_site_name_path
  end
end

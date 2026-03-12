# frozen_string_literal: true

# A stats component to display number of articles by site_name
class Stats::ArticlesBySitenameComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  attr_reader :data, :total

  # data = { "site name 1" => 1, "site name 2" => 10 }
  def initialize(data = nil, frame_url: nil, total: nil)
    @data = data
    @frame_url = frame_url
    @total = total
    super()
  end

  def frame_id
    "frame_#{id}"
  end

  def frame_url
    @frame_url || stats_articles_by_site_name_path
  end

  def uniq_key
    ""
  end
end

# frozen_string_literal: true

# Displays total number of Article
class Stats::TotalArticlesComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_total_articles_path
  end
end

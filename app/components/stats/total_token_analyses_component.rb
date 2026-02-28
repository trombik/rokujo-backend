# frozen_string_literal: true

# A compoent to display the total number of TokenAnalyses
class Stats::TotalTokenAnalysesComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_total_token_analyses_path
  end
end

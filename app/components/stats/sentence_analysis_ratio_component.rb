# frozen_string_literal: true

# Displays analyzed sentences in percentage
class Stats::SentenceAnalysisRatioComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_sentence_analysis_ratio_path
  end
end

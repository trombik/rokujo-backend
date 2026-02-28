# frozen_string_literal: true

# Displays total number of Sentence
class Stats::TotalSentencesComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_total_sentences_path
  end
end

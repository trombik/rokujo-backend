# frozen_string_literal: true

# A number of articles without sentences
class Stats::ArticlesWithoutSentenceComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_articles_without_sentence_path
  end
end

# frozen_string_literal: true

# Displays the number of sentences per article
class Stats::SentencesPerArticleComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_sentences_per_article_path
  end
end

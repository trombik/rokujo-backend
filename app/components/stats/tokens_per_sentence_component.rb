# frozen_string_literal: true

# Displays the number of tokens per sentence
class Stats::TokensPerSentenceComponent < Stats::SingleNumberComponent
  def frame_url
    @frame_url || stats_tokens_per_sentence_path
  end
end

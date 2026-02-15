# frozen_string_literal: true

# A card for sentences.
#
# The component highlights the matched keyword and has links to the original
# URL, the article oage, and displays metadata of the article.
class Sentence::CardComponent < ViewComponent::Base
  attr_reader :sentence, :word

  def initialize(sentence, word)
    @sentence = sentence
    @word = word
    super()
  end

  delegate :article, to: :sentence

  def published_year
    time = article.published_time.presence || article.acquired_time.presence
    time.in_time_zone.strftime("%Y")
  rescue StandardError
    false
  end

  def article_title
    return if article.title.blank?

    article.title.truncate_bytes(80)
  end

  def article_site_name
    return false if article.site_name.blank?

    article.site_name.truncate_bytes(30)
  end

  def decorated_text
    pattern = Regexp.new(word, Regexp::IGNORECASE)
    highlighted_text = sentence.text.gsub(pattern) { |match| "<span class='bg-warning'>#{match}</span>" }

    sanitize highlighted_text, tags: %w[span], attributes: %w[class]
  rescue StandardError
    sentence.text
  end
end

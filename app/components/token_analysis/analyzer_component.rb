# frozen_string_literal: true

# Displays token analysis of a sentence
class TokenAnalysis::AnalyzerComponent < ViewComponent::Base
  attr_reader :text, :tokens

  def initialize(text, tokens)
    @text = text
    @tokens = tokens.map(&:symbolize_keys)
    super()
  end

  def pos_color(pos)
    case pos
    when "NOUN" then "success"
    when "VERB" then "danger"
    when "ADJ"  then "warning text-dark"
    when "PROPN" then "primary"
    when "AUX" then "info text-dark"
    when "ADP" then "light text-dark border"
    else "secondary"
    end
  end

  def extract_reading(morph)
    extract_from_morph(morph, "Reading")
  end

  def extract_inflection(morph)
    extract_from_morph(morph, "Inflection")
  end

  def extract_from_morph(morph, key)
    return unless morph || key

    morph.match(/#{key}=([^|]+)/)&.captures&.first
  end

  def head(token)
    return unless token[:head] || tokens

    tokens[token[:head]]
  end
end

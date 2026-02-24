# frozen_string_literal: true

# A component to display search results of modifiers with a noun
class Collocations::ModifierComponent < ViewComponent::Base
  attr_reader :noun, :patterns, :type

  def initialize(noun, patterns, type)
    @noun = noun
    @patterns = patterns || []
    @type = type
    super()
  end

  # rubocop:disable Metrics/MethodLength
  def type_name
    case type
    when "amod"
      "形容詞修飾"
    when "nmod"
      "名詞句修飾"
    when "compound"
      "複合語"
    when "acl"
      "連体修飾節"
    when "appos"
      "同格"
    else
      "Unknown: #{type}"
    end
  end

  def type_desc
    case type
    when "amod"
      "なんとかな#{noun}"
    when "nmod"
      "なんとかの#{noun}"
    when "compound"
      "なんとか#{noun}"
    when "acl"
      "なんとかする#{noun}"
    when "appos"
      "なんとかという#{noun}"
    else
      "Unknown: #{type}"
    end
  end
  # rubocop:enable Metrics/MethodLength
end

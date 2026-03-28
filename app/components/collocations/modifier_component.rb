# frozen_string_literal: true

# A component to display search result of modifiers with a noun
class Collocations::ModifierComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  attr_reader :noun, :result, :type, :minimum_freqeuncy

  def initialize(type, noun = nil, result = {}, minimum_freqeuncy: 3)
    @noun = noun
    @result = result
    @type = type
    @minimum_freqeuncy = minimum_freqeuncy
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

  def frequent_words
    result.select { |_word, count| count >= minimum_freqeuncy }.to_a
  end

  def less_frequent_words
    result.select { |_word, count| count < minimum_freqeuncy }.to_a
  end

  def collapsed_part_id
    "#{id}_collapsed_part"
  end

  def uniq_key
    type
  end

  def frame_id
    "#{self.class.name.underscore.parameterize}_#{type}"
  end

  def button_component
    ToggleButton.new(n_items: less_frequent_words.size,
                     target_id: collapsed_part_id,
                     text: t(".see_all"))
  end

  # the button to show words_less_than_or_equal_to
  class ToggleButton < ViewComponent::Base
    include Concerns::IdentifiableComponent

    def initialize(n_items:, target_id:, text:)
      @n_items = n_items
      @target_id = target_id
      @text = text
      super()
    end

    def render?
      n_items.positive?
    end

    def call
      tag.button class: "btn btn-primary btn-sm",
                 data: {
                   testid: testid,
                   bs_toggle: "collapse",
                   bs_target: "##{target_id}"
                 },
                 aria: { expanded: false, controls: target_id } do
        text
      end
    end

    private

    attr_reader :n_items, :target_id, :text
  end
end

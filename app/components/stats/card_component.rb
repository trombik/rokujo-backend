# frozen_string_literal: true

# A card for statistical numbers
class Stats::CardComponent < ViewComponent::Base
  renders_one :title

  def initialize(classes: "")
    @classes = classes
    super()
  end

  private

  def classes
    "card shadow-sm h-100 #{@classes}".strip
  end
end

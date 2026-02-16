# frozen_string_literal: true

# A component to display search results of modifiers with a noun
class Collocations::ModifierComponent < ViewComponent::Base
  attr_reader :noun, :results

  def initialize(noun, results)
    @noun = noun
    @results = results
    super()
  end

  def sorted_results
    results.sort_by { |(modifiers, noun), _count| [modifiers, noun] }
  end
end

# frozen_string_literal: true

# Displays search results of verbs with a noun
class Collocations::VerbWithNounComponent < ViewComponent::Base
  attr_reader :noun, :results

  def initialize(noun, results)
    @noun = noun
    @results = results
    super()
  end

  def sorted_results
    results.sort_by { |(particle, verb), _count| [particle, verb] }
  end
end

# frozen_string_literal: true

# Displays search results of verbs with a noun
class Collocations::VerbWithNounComponent < ViewComponent::Base
  attr_reader :noun, :results

  def initialize(noun, results)
    @noun = noun
    @results = results
    super()
  end
end

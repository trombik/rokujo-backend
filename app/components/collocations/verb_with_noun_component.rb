# frozen_string_literal: true

# Displays search results of verbs with a noun
class Collocations::VerbWithNounComponent < ViewComponent::Base
  attr_reader :noun, :results

  def initialize(noun, results = nil)
    @noun = noun
    @results = results
    super()
  end

  def frame_id
    self.class.name.underscore.parameterize
  end
end

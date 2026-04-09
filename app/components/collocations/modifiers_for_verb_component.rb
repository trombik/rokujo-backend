# frozen_string_literal: true

class Collocations::ModifiersForVerbComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(verb, results = nil)
    @verb = verb
    @results = results
    super()
  end

  def frame_id
    "frame-#{id}"
  end

  private

  def header_string
    "Modifiers for #{verb}"
  end

  attr_reader :verb, :results

  def uniq_key
    "not_uniq"
  end
end

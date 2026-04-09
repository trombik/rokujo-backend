# frozen_string_literal: true

class Collocations::ModifiersForVerbComponentPreview < ViewComponent::Preview
  def default
    verb = "行動"
    results = VerbModifierExtractor.new(lemma: verb).call
    render Collocations::ModifiersForVerbComponent.new(verb, results)
  end
end

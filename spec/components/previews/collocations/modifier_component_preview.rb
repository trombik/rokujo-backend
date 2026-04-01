# frozen_string_literal: true

class Collocations::ModifierComponentPreview < ViewComponent::Preview
  # @param lemma text "A noun"
  # @param type select { choices: ["amod", "nmod", "acl", "compound"] }
  def default(type: "acl", lemma: "対策")
    results = NounPhraseExtractor.new(lemma: lemma, deps: [type]).call
    render Collocations::ModifierComponent.new(type, lemma, results)
  end
end

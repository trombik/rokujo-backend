# frozen_string_literal: true

class Collocations::ModifierComponentPreview < ViewComponent::Preview
  def default
    type = "acl"
    lemma = "首相"
    results = NounPhraseExtractor.new(lemma: lemma, deps: [type]).call
    render Collocations::ModifierComponent.new(type, lemma, results)
  end
end

# frozen_string_literal: true

class Collocations::ModifierComponentPreview < ViewComponent::Preview
  def default
    type = "acl"
    lemma = "データ"
    results = TokenAnalysis.find_modifier_patterns_for(lemma, by: type)
    render Collocations::ModifierComponent.new(type, lemma, results)
  end
end

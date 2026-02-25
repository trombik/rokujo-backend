# frozen_string_literal: true

class Collocations::VerbWithNounComponentPreview < ViewComponent::Preview
  def default
    noun = "データ"
    results = TokenAnalysis.find_verb_collocations_by_noun(noun)
    render Collocations::VerbWithNounComponent.new(noun, results)
  end
end

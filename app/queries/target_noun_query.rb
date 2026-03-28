# Target NOUN tokens
class TargetNounQuery
  def initialize(lemma:)
    @lemma = lemma
  end

  def call
    TokenAnalysis.where(lemma: lemma, pos: pos)
  end

  private

  attr_reader :lemma

  def pos
    "NOUN"
  end
end

# Taget Verb tokens
class TargetVerbQuery
  def initialize(lemma:)
    @lemma = lemma
  end

  def call
    TokenAnalysis.where(lemma: lemma, pos: pos)
  end

  private

  attr_reader :lemma

  def pos
    "VERB"
  end
end

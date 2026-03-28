# Collocations for noun
class Collocations::NounsController < ApplicationController
  before_action :set_lemma_and_type

  def index; end

  def verbs
    @results = @lemma.present? ? TokenAnalysis.find_verb_collocations_by_noun(@lemma) : nil

    respond_to do |format|
      format.turbo_stream
    end
  end

  def adjectives
    return head :not_acceptable unless %w[appos nmod acl amod compound].include? @type

    @results = @lemma.present? ? NounPhraseExtractor.new(lemma: @lemma, deps: [@type]).call : []
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_lemma_and_type
    @lemma = params[:lemma]&.strip
    @type = params[:type]&.strip
  end
end

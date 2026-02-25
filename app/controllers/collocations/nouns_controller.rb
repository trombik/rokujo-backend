# Collocations for noun
class Collocations::NounsController < ApplicationController
  def index
    @lemma = params[:lemma]
  end

  def verbs
    @lemma = params[:lemma]
    @results = @lemma ? TokenAnalysis.find_verb_collocations_by_noun(@lemma) : nil

    respond_to do |format|
      format.turbo_stream
    end
  end

  def adjectives
    @lemma = params[:lemma]
    @type = params[:type]
    return head :not_acceptable unless %w[appos nmod acl amod compound].include? @type

    @results = @lemma ? TokenAnalysis.find_modifier_patterns_for(@lemma, by: @type) : []
    respond_to do |format|
      format.turbo_stream
    end
  end
end

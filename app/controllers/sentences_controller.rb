# SentencesController
class SentencesController < ApplicationController
  def index
    @word = params[:word]
    @pagy, @sentences = if @word
                          pagy(:countish, Sentence.includes(:article).match(@word), items: 20)
                        else
                          [nil, []]
                        end
  end

  def collocations
    @noun = params[:noun]
  end

  def verb_collocations_by_noun
    @noun = params[:noun]
    @results = @noun ? TokenAnalysis.find_verb_collocations_by_noun(@noun) : {}

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def adjective_modifiers_by_noun
    @noun = params[:noun]
    @results = @noun ? TokenAnalysis.find_adjective_modifiers_by_noun(@noun) : {}

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end

# SentencesController
class SentencesController < ApplicationController
  def index
    @word = params[:word]&.split(/\s+/)&.first
    operators = helpers.operators_from(params[:word])
    @pagy, @sentences = if @word
                          pagy(:countish,
                               Sentence.search_with_operators(@word, operators),
                               items: 20)
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

  def show_sentences_with_particle_and_verb
    @noun = params[:noun]
    @particle = params[:particle]
    @verb = params[:verb]
    @sentences = Sentence.find_sentences_with_particle_and_verb(@noun, @particle, @verb)

    respond_to do |format|
      format.html
    end
  end
end

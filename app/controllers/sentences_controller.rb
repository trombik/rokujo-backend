# SentencesController
class SentencesController < ApplicationController
  def index
    @word = extract_word(params[:word])
    operators = helpers.operators_from(params[:word])
    @pagy, @sentences = if @word
                          pagy(:countish,
                               Sentence.search_with_operators(@word, operators),
                               items: 20)
                        else
                          [nil, []]
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

  def extract_word(word)
    params[:word].strip.split(/\s+/).first if word
  end
end

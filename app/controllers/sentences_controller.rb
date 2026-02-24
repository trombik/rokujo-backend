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
    @type = params[:type]
    @patterns = @noun ? TokenAnalysis.find_modifier_patterns_for(@noun, by: params[:type]) : []

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

  def by_noun_and_modifier
    @noun = params[:noun]
    @modifier = params[:modifier]
    @token_analyses = TokenAnalysis.joins("INNER JOIN token_analyses AS modifiers ON
                         modifiers.article_uuid = token_analyses.article_uuid AND
                         modifiers.line_number  = token_analyses.line_number AND
                         modifiers.head         = token_analyses.token_id")
                                   .where(token_analyses: { lemma: @noun }, modifiers: { text: @modifier })
                                   .select(:article_uuid, :line_number)
                                   .includes(:sentence)
                                   .distinct
                                   .limit(20)
    @sentences = @token_analyses.map(&:sentence)
  end

  def extract_word(word)
    params[:word].strip.split(/\s+/).first if word
  end
end

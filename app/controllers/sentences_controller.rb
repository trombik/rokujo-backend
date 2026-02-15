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
end

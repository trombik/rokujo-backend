# SentencesController
class SentencesController < ApplicationController
  def index
    @word = params[:word]
    @sentences = @word ? Sentence.match(@word).limit(10) : []
  end
end

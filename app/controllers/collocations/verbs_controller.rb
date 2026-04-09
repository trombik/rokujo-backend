class Collocations::VerbsController < ApplicationController
  before_action :set_lemma

  def index; end

  def modifiers
    @results = @lemma.present? ? VerbModifierExtractor.new(lemma: @lemma).call : []
    respond_to :html
    render layout: false
  end

  private

  def set_lemma
    @lemma = params[:lemma]&.strip
  end
end

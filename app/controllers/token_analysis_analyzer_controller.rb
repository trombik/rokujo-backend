# accept q query and displays token analysis of a sentence
class TokenAnalysisAnalyzerController < ApplicationController
  def index
    return unless params&.key?(:text)

    @text = params[:text].strip
    @tokens = TextAnalysisService.call(@text) if @text.present?
  end
end

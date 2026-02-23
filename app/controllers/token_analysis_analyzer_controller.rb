# accept q query and displays token analysis of a sentence
class TokenAnalysisAnalyzerController < ApplicationController
  def index
    @text = params[:text]&.strip
    @tokens = @text.present? ? TextAnalysisService.call(@text) : []

    respond_to do |format|
      format.html
      format.json do
        render json: {
          text: @text,
          tokens: @tokens
        }
      end
    end
  end
end

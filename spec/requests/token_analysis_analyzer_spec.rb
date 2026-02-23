require "rails_helper"

RSpec.describe "TokenAnalysisAnalyzers", type: :request do
  describe "GET /index" do
    context "when no text is given" do
      it "renders success" do
        get "/token_analysis_analyzer"
        expect(response).to have_http_status(:success)
      end
    end

    context "when a text is given" do
      it "shows token analysis" do
        get "/token_analysis_analyzer", params: { text: "こんにちは" }

        expect(response).to have_http_status(:success)
      end
    end
  end
end

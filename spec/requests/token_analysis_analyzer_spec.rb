require "rails_helper"

RSpec.describe "TokenAnalysisAnalyzers", type: :request do
  let(:path) { token_analysis_analyzer_path }

  describe "GET /index" do
    context "when no text is given" do
      it "renders success" do
        get path
        expect(response).to have_http_status(:success)
      end
    end

    context "when a text is given" do
      it "shows token analysis" do
        get path, params: { text: "こんにちは" }

        expect(response).to have_http_status(:success)
      end
    end

    context "when JSON format is requested" do
      before do
        get path, params: { text: "こんにちは" }, as: :json
      end

      it "returns the result as a JSON" do
        expect(response).to have_http_status(:success)
      end

      specify "the response is application/json" do
        expect(response.media_type).to eq("application/json")
      end
    end

    context "when text params does not exist" do
      it "returns success" do
        get path

        expect(response).to have_http_status(:success)
      end

      it "returns empty JSON response when the JSON format is requested" do
        get path, as: :json

        json = response.parsed_body
        expect(json.deep_symbolize_keys).to eq({ text: nil, tokens: [] })
      end
    end
  end
end

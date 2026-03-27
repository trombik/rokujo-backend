require "rails_helper"

RSpec.describe "Sentences", type: :request do
  describe "GET /index" do
    it "returns success" do
      get sentences_index_path

      expect(response).to have_http_status(:success)
    end

    context "when search word is given" do
      it "returns success" do
        get sentences_index_path(word: "foo")

        expect(response).to have_http_status(:success)
      end
    end
  end
end

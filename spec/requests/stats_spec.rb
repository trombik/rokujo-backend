require "rails_helper"

RSpec.describe "Stats", type: :request do
  describe "GET /total_articles" do
    it "returns success" do
      get stats_total_articles_path

      expect(response).to have_http_status(:success)
    end
  end
end

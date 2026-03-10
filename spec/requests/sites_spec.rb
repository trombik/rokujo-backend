require "rails_helper"

RSpec.describe "Sites", type: :request do
  let(:article) do
    create(:article, site_name: "Example site")
  end

  include ERB::Util

  describe "GET /index" do
    it "returns http success" do
      article
      get sites_index_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get sites_show_path(article.site_name)

      expect(response).to have_http_status(:success)
    end
  end
end

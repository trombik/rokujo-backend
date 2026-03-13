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

  describe "DELETE /destroy/:site_name" do
    it "deletes the article of the site_name and article_collection" do
      create(:article_collection, key: "site_name", value: article.site_name)

      expect do
        delete sites_destroy_path(article.site_name)
      end.to change(Article, :count).by(-1).and change(ArticleCollection, :count).by(-1)
    end
  end
end

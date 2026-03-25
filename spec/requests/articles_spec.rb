require "rails_helper"

RSpec.describe "Articles", type: :request do
  let(:sentences) { create_list(:sentence, 2) }
  let(:article) { create(:article, sentences: sentences) }

  describe "GET /articles/:uuid" do
    it "returns not_found when the article does not exist" do
      get "/articles/foo-bar-buz"

      expect(response).to have_http_status(:not_found)
    end

    it "renders success" do
      get "/articles/#{article.uuid}"

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /articles/:uuid/:line_number" do
    it "returns not_found when the article does not exist" do
      get "/articles/foo-bar-buz/1"

      expect(response).to have_http_status(:not_found)
    end

    it "returns success" do
      get "/articles/#{article.uuid}/#{sentences.first.line_number}"

      expect(response).to have_http_status(:success)
    end

    context "when the line_number does not exist in the sentences" do
      it "returns not_found" do
        get "/article/#{article.uuid}/1000"

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /articles" do
    it "returns success" do
      get articles_index_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /articles/without_site_name" do
    it "returns success" do
      get articles_without_site_name_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested article" do
      article = create(:article)

      expect do
        delete articles_destroy_path(uuid: article.uuid)
      end.to change(Article, :count).by(-1)
    end

    context "when the article does not exist" do
      it "returns not_found" do
        delete articles_destroy_path(uuid: "no-such-article")

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

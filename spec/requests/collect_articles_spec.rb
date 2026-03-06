require "rails_helper"

RSpec.describe "CollectArticles", type: :request do
  let(:spider) { "read-more" }
  let(:status) { instance_double(Process::Status) }

  before do
    # mock Open3 because we really do not want to perform any jobs in request
    # specs. The controller under test does not use perform_now, but even if
    # it is called for any reasons, do not run the job.
    allow(status).to receive(:success?).and_return(true)
    allow(Open3).to receive(:capture3).and_return("", "", status)
  end

  describe "GET /index" do
    it "returns http success" do
      get collect_articles_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_collect_article_path(spider: spider)

      expect(response).to have_http_status(:success)
    end

    context "when spider is unsupported one" do
      let(:spider) { "no-such-spider" }

      it "redirects to collect_articles_path" do
        get new_collect_article_path, params: { spider: spider, urls: "http://example.org" }

        expect(response).to redirect_to(collect_articles_path)
      end
    end

    context "when spider is sitemap" do
      let(:spider) { "sitemap" }

      it "returns http success" do
        get new_collect_article_path(spider: spider)

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /create" do
    let(:valid_params) do
      {
        spider: spider,
        urls: "http://example.org/path"
      }
    end

    let(:params_with_extra) do
      {
        spider: spider,
        foobarbuz: "invalid"
      }
    end

    it "redirect_to collect_articles_path" do
      post collect_articles_path, params: valid_params

      expect(response).to redirect_to(collect_articles_path)
    end

    context "when extra option is given" do
      it "filters out unknown options and enqueues the job" do
        expect do
          post collect_articles_path, params: params_with_extra
        end.to have_enqueued_job(CollectArticlesJob).with(
          "read-more",
          hash_excluding("foobarbuz")
        )
      end

      it "redirects to collect_articles_path" do
        post collect_articles_path, params: params_with_extra

        expect(response).to redirect_to(collect_articles_path)
      end
    end

    context "when spider is unsupported one" do
      let(:spider) { "no-such-spider" }

      it "returns :not_found" do
        post collect_articles_path, params: valid_params

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when spider is sitemap" do
      let(:spider) { "sitemap" }

      it "redirects to collect_articles_path" do
        post collect_articles_path, params: valid_params

        expect(response).to redirect_to(collect_articles_path)
      end
    end
  end
end

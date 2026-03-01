require "rails_helper"

RSpec.describe "Stats", type: :request do
  describe "GET /" do
    it "returns success" do
      get stats_index_path

      expect(response).to have_http_status(:success)
    end
  end

  shared_examples "a turbo_stream stats endpoint" do
    context "when requested as HTML" do
      before { get path, as: :html }

      it { expect(response).to have_http_status(:success) }
      it { expect(response.media_type).to eq "text/html" }
    end

    context "when requested as turbo_stream" do
      before { get path, as: :turbo_stream }

      it { expect(response).to have_http_status(:success) }
      it { expect(response.media_type).to eq "text/vnd.turbo-stream.html" }
    end
  end

  describe "GET /total_articles" do
    let(:path) { stats_total_articles_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /total_sentences" do
    let(:path) { stats_total_sentences_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /total_token_analyses" do
    let(:path) { stats_total_token_analyses_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /sentence_analysis_ratio" do
    let(:path) { stats_sentence_analysis_ratio_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /sentences_per_article" do
    let(:path) { stats_sentences_per_article_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /tokens_per_sentence" do
    let(:path) { stats_tokens_per_sentence_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /articles_by_site_name" do
    let(:path) { stats_articles_by_site_name_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end

  describe "GET /sentences_by_site_name" do
    let(:path) { stats_sentences_by_site_name_path }

    it_behaves_like "a turbo_stream stats endpoint"
  end
end

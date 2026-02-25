require "rails_helper"

RSpec.describe "Collocations::Nouns", type: :request do
  subject(:send_request) do
    get path, params: params, as: as
  end

  let(:lemma) { "データ" }
  let(:path) { collocations_nouns_index_path }
  let(:params) { { lemma: lemma } }
  let(:as) { :turbo_stream }

  before do
    send_request
  end

  describe "GET /index" do
    let(:as) { :html }

    context "when lemma is given" do
      it "returns :success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when no params is given" do
      let(:params) { {} }

      it "returns success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /verbs" do
    let(:path) { collocations_nouns_verbs_path }

    context "when lemma is given" do
      it "returns :success" do
        expect(response).to have_http_status(:success)
      end

      it "accepts turbo_stream request and returns turbo_stream as response", :aggregate_failures do
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      end
    end

    context "when lemma is not given" do
      let(:params) { {} }

      it "returns :success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when request format is html" do
      let(:as) { :html }

      it "returns not_acceptable" do
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end

  describe "GET adjectives" do
    let(:path) { collocations_nouns_adjectives_path }
    let(:params) { { lemma: lemma, type: "acl" } }

    it "returns success" do
      expect(response).to have_http_status(:success)
    end

    context "when request format is html" do
      let(:as) { :html }

      it "returns not_acceptable" do
        expect(response).to have_http_status(:not_acceptable)
      end
    end

    context "when type is unknown type" do
      let(:params) { { lemma: lemma, type: "foo" } }

      it "returns not_acceptable" do
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end
end

require "rails_helper"

RSpec.describe "Collocations::Verbs", type: :request do
  subject(:res) do
    get path, params: params, as: as
    response
  end

  let(:path) { collocations_verbs_index_path }
  let(:lemma) { "行動" }
  let(:as) { :html }
  let(:params) { { lemma: lemma } }

  describe "GET /index" do
    it { is_expected.to have_http_status(:success) }
  end

  describe "GET /modifiers" do
    let(:path) { collocations_verbs_modifiers_path }

    it { is_expected.to have_http_status(:success) }
  end
end

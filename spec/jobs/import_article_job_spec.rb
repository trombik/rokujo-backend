require "rails_helper"

RSpec.describe ImportArticleJob, type: :job do
  let(:article) { create(:article) }

  before do
    create(:sentence, article: article)
  end

  describe "#perform_now" do
    before do
      allow(Article).to receive(:import_from_hash!).and_return(article)
    end

    context "when the article is not unique" do
      before do
        allow(Article).to receive(:import_from_hash!).and_raise(ActiveRecord::RecordNotUnique)
      end

      it "discards the job" do
        expect do
          described_class.perform_now({})
        end.not_to raise_error
      end
    end
  end
end

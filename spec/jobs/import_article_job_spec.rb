require "rails_helper"

RSpec.describe ImportArticleJob, type: :job do
  before do
    article = create(:article)
    create(:sentence, article: article)
    allow(Article).to receive(:import_from_hash!).and_return(article)
  end

  describe "#perform_now" do
    it "enqueue AnalyzeTokensJob" do
      expect do
        described_class.perform_now({})
      end.to have_enqueued_job(AnalyzeTokensJob)
    end

    context "when AnalyzeTokensJob failed perform_later" do
      before do
        allow(AnalyzeTokensJob).to receive(:perform_later).and_raise(StandardError)
      end

      it "raises EnqueueError" do
        expect do
          described_class.perform_now({})
        end.to raise_error ImportArticleJob::EnqueueError
      end
    end
  end
end

require "rails_helper"

RSpec.describe ImportArticleJob, type: :job do
  let(:article) { build(:article) }
  let(:token) { build(:token_analysis) }
  let(:sentence) { build(:sentence, article: article, line_number: 1, text: token.text) }
  let(:hash) do
    hash = article.attributes
    hash["sentences"] = [sentence.text]
    hash["tokens"] = [token.attributes]
    hash
  end

  describe "#perform_now" do
    it "creates an Article" do
      expect do
        described_class.perform_now(hash)
      end.to change(Article, :count).by(1)
    end

    it "enqueues ImportSentenceJob" do
      expect do
        described_class.perform_now(hash)
      end.to have_enqueued_job(ImportSentenceJob)
    end

    context "when the article is not Japanese" do
      let(:article) { build(:article, lang: "en") }

      it "does not enqueue ImportSentenceJob" do
        expect do
          described_class.perform_now(hash)
        end.not_to have_enqueued_job(ImportSentenceJob)
      end
    end

    context "when sentences is empty" do
      it "raises MissingSentencesError" do
        hash["sentences"] = []
        expect do
          described_class.perform_now(hash)
        end.to raise_error described_class::MissingSentencesError
      end
    end

    context "when tokens is empty" do
      it "raises MissingTokensError" do
        hash["tokens"] = []
        expect do
          described_class.perform_now(hash)
        end.to raise_error described_class::MissingTokensError
      end
    end

    context "when the article is not unique" do
      before do
        allow(Article).to receive(:import_from_hash!).and_raise(ActiveRecord::RecordNotUnique)
      end

      it "discards the job" do
        expect do
          described_class.perform_now(hash)
        end.not_to raise_error
      end
    end

    context "when another article with the same normalized_url exists" do
      before do
        create(:article, url: article.url)
      end

      it "does not import the article" do
        allow(Article).to receive(:import_from_hash!)
        described_class.perform_now(hash)

        expect(Article).not_to have_received(:import_from_hash!)
      end

      it "does not enqueue ImportSentenceJob" do
        expect do
          described_class.perform_now(hash)
        end.not_to have_enqueued_job(ImportSentenceJob)
      end
    end
  end
end

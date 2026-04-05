require "rails_helper"

RSpec.describe ImportSentenceJob, type: :job do
  include_context "with an article"
  let(:token) { build(:token_analysis) }
  let(:sentence) { build(:sentence, article: article, line_number: 1, text: token.text) }

  it "creates a Sentence" do
    expect do
      described_class.perform_now(article_uuid: article.uuid,
                                  line_number: sentence.line_number,
                                  text: sentence.text,
                                  tokens: [token.attributes])
    end.to change(Sentence, :count).by(1)
  end

  it "enqueues ImportTokenJob" do
    expect do
      described_class.perform_now(article_uuid: article.uuid,
                                  line_number: sentence.line_number,
                                  text: sentence.text,
                                  tokens: [token.attributes])
    end.to have_enqueued_job(ImportTokenJob)
  end
end

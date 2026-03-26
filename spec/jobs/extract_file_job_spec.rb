require "rails_helper"

RSpec.describe ExtractFileJob, type: :job do
  let(:file) { Rails.root.join("spec/fixtures/files/test.pdf").to_s }

  it "enqueues ImportArticleJob" do
    expect do
      described_class.perform_now(file, Rokujo::Extractor::Parsers::PDF.name)
    end.to have_enqueued_job(ImportArticleJob)
  end

  context "with docx" do
    let(:file) { Rails.root.join("spec/fixtures/files/test.docx").to_s }

    it "enqueues ImportArticleJob" do
      expect do
        described_class.perform_now(file, Rokujo::Extractor::Parsers::Docx.name)
      end.to have_enqueued_job(ImportArticleJob)
    end
  end
end

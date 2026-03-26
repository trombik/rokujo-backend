require "rails_helper"

RSpec.describe ImportFileJob, type: :job do
  let(:file) { Rails.root.join("spec/fixtures/files/test.jsonl").to_s }

  it "enqueues ExtractFileJob with Article parser" do
    expect do
      described_class.perform_now(file)
    end.to have_enqueued_job(ExtractArticlesJob).with(file)
  end

  context "with docx file" do
    let(:file) { Rails.root.join("spec/fixtures/files/test.docx").to_s }

    it "enqueues ExtractFileJob with Docx parser" do
      expect do
        described_class.perform_now(file)
      end.to have_enqueued_job(ExtractFileJob).with(file, Rokujo::Extractor::Parsers::Docx.name)
    end
  end

  context "with pdf file" do
    let(:file) { Rails.root.join("spec/fixtures/files/test.pdf").to_s }

    it "enqueues ExtractFileJob with PDF parser" do
      expect do
        described_class.perform_now(file)
      end.to have_enqueued_job(ExtractFileJob).with(file, Rokujo::Extractor::Parsers::PDF.name)
    end
  end

  context "with unsupported file" do
    let(:file) { Rails.root.join("spec/fixtures/files/empty.txt").to_s }

    it "raises UnsupportedFile" do
      expect do
        described_class.perform_now(file)
      end.to raise_error ImportFileJob::UnsupportedFileError
    end
  end

  context "with mimicked_pdf.pdf" do
    let(:file) { Rails.root.join("spec/fixtures/files/mimicked_as_pdf.pdf").to_s }

    it "raises UnknownFile" do
      expect do
        described_class.perform_now(file)
      end.to raise_error ImportFileJob::UnknownFileError
    end
  end
end

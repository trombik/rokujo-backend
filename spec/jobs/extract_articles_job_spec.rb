require "rails_helper"

RSpec.describe ExtractArticlesJob, type: :job do
  let(:parser) { instance_double(Rokujo::Extractor::Parsers::Article) }

  before do
    allow(File).to receive_messages(exist?: true, empty?: false, foreach: %w[foo].each)
    allow(parser).to receive_messages(extract_sentences: nil, item: {})
    allow(Rokujo::Extractor::Parsers::Article).to receive(:new).and_return parser
  end

  describe "#perform" do
    context "when extracting article successfully finishes" do
      it "enqueue ImportArticleJob" do
        expect do
          described_class.perform_now("/path/to/file")
        end.to have_enqueued_job(ImportArticleJob)
      end
    end

    context "when perform_later fails" do
      before do
        allow(ImportArticleJob).to receive(:perform_later).and_return(nil)
      end

      it "raises EnqueueError" do
        expect do
          described_class.perform_now("/path/to/file")
        end.to raise_error ExtractArticlesJob::EnqueueError
      end
    end

    context "when extracting article fails" do
      before do
        allow(parser).to receive(:extract_sentences).and_raise(StandardError)
      end

      it "raises ParserError" do
        expect do
          described_class.perform_now("/path/to/file")
        end.to raise_error ExtractArticlesJob::ParserError
      end
    end

    context "when the file does not exist" do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it "raises RuntimeError" do
        expect do
          described_class.perform_now("/path/to/file")
        end.to raise_error ExtractArticlesJob::FileNotFoundError
      end
    end

    context "when the file is empty" do
      before do
        allow(File).to receive(:empty?).and_return(true)
      end

      it "raises EmptyFileError" do
        expect do
          described_class.perform_now("/path/to/file")
        end.to raise_error ExtractArticlesJob::EmptyFileError
      end
    end
  end
end

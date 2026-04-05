require "rails_helper"

RSpec.describe ImportFileJob, type: :job do
  let(:file) { "/path/to/file" }
  let(:jsonl) { [{ "foo" => "bar" }.to_json].join("\n") }
  let(:io) { StringIO.new(jsonl) }

  before do
    allow(File).to receive(:open).and_yield(io)
  end

  it "enqueues ImportArticleJob" do
    expect do
      described_class.perform_now(file)
    end.to have_enqueued_job(ImportArticleJob)
  end

  context "when jsonl contains an invalid json" do
    let(:jsonl) { ["invalid json", { "foo" => "bar" }.to_json].join("\n") }

    it "does not raise JSON::ParserError" do
      expect do
        described_class.perform_now(file)
      end.not_to raise_error
    end

    it "enqueues the next valid json" do
      expect do
        described_class.perform_now(file)
      end.to have_enqueued_job(ImportArticleJob)
    end
  end
end

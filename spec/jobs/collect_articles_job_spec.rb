require "rails_helper"

RSpec.describe CollectArticlesJob, type: :job do
  let(:spider_name) { "read-more" }
  let(:args) { { "urls" => "http://example.org/path" } }
  let(:status) { instance_double(Process::Status, success?: true) }
  let(:service_double) do
    instance_double(
      CollectArticlesService,
      call: ["/path/to/file", status],
      stdout: "success",
      stderr: ""
    )
  end

  before do
    allow(CollectArticlesService).to receive(:new).with(spider_name, args).and_return(service_double)
    allow(FileUtils).to receive(:rm).and_return(true)
  end

  describe "#perform" do
    it "creates a CollectArticlesService instance with correct arguments" do
      described_class.perform_now(spider_name, args)
      expect(CollectArticlesService).to have_received(:new).with(spider_name, args)
    end

    it "calls the service instance" do
      described_class.perform_now(spider_name, args)
      expect(service_double).to have_received(:call)
    end

    context "when the service fails" do
      let(:status) { instance_double(Process::Status, success?: false) }

      before do
        allow(service_double).to receive(:call).and_return([nil, status])
      end

      it "raises an exception" do
        expect do
          described_class.perform_now(spider_name, args)
        end.to raise_error(RuntimeError)
      end
    end
  end
end

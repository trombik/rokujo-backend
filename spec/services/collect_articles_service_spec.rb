require "rails_helper"

RSpec.describe CollectArticlesService do
  let(:args) do
    {
      urls: ["http://example.org/path", "http://example.net/path"].join(","),
      read_next: "次へ"
    }
  end

  let(:status_double) { instance_double(Process::Status) }
  let(:service) { described_class.new("generic", args, output_dir: output_dir) }
  let!(:output_dir) { Dir.mktmpdir }

  before do
    allow(Open3).to receive(:popen3).and_return(status_double)
  end

  after do
    FileUtils.rm_rf output_dir
  end

  describe "#call" do
    context "when the process successfully exits" do
      before do
        allow(status_double).to receive(:success?).and_return(true)
      end

      it "returns success status" do
        _f, status = service.call

        expect(status).to be_success
      end

      it "creates output_file" do
        file, _status = service.call

        expect(file).to exist
      end

      it "calls Open3.popen3 with correct scrapy arguments", :aggregate_failures do
        service.call

        expect(Open3).to have_received(:popen3) do |*cmds|
          expect(cmds).to include("urls=#{args[:urls]}", "read_next=#{args[:read_next]}")
        end
      end
    end

    context "when an argument is omitted" do
      let(:args) do
        {
          urls: "http://example.org/path",
          read_next: ""
        }
      end

      before do
        allow(status_double).to receive(:success?).and_return(true)
      end

      it "does not append the ommitted argument", :aggregate_failures do
        service.call
        expect(Open3).to have_received(:popen3) do |*cmds|
          expect(cmds).not_to include("read_next=")
        end
      end
    end

    context "when the process fails" do
      before do
        allow(status_double).to receive(:success?).and_return(false)
      end

      it "returns success status" do
        _f, status = service.call

        expect(status).not_to be_success
      end

      it "returns nul as output_file" do
        file, _status = service.call

        expect(file).to be_nil
      end
    end
  end
end

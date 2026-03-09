require "rails_helper"

RSpec.describe NormalizeUrlService do
  let(:url) { "" }
  let(:service) { described_class.new(url) }

  describe "#call" do
    context "when url is empty string" do
      it "returns empty string" do
        expect(service.call).to eq ""
      end
    end

    context "when url is nil" do
      let(:url) { nil }

      it "returns empty string" do
        expect(service.call).to eq ""
      end
    end

    context "when url a correct URL" do
      let(:url) { "https://example.org/path" }

      it "returns a normalized URL" do
        expect(service.call).to eq "example.org/path"
      end
    end

    context "when path part of the URL is ony `/`" do
      let(:url) { "https://example.org/" }

      it "omits `/`" do
        expect(service.call).to eq "example.org"
      end
    end

    context "when the URL includes query strings" do
      let(:url) { "https://example.org/path?q=foo" }

      it "removes the query strings" do
        expect(service.call).to eq "example.org/path"
      end
    end
  end
end

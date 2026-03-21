require "rails_helper"

RSpec.describe Tei2htmlService do
  let(:call_service) { described_class.call(string) }
  let(:string) { "" }

  context "with lb nodes" do
    let(:string) { "<lb></lb>" }

    it "removes lb nodes" do
      expect(call_service).to eq ""
    end
  end

  context "with quote nodes" do
    let(:string) { "<quote>foo</quote>" }

    it "replace thme with blockquote" do
      expect(call_service).to eq "<blockquote>foo</blockquote>"
    end
  end

  context "with item nodes" do
    let(:string) { "<item>foo</item>" }

    it "replace thme with li" do
      expect(call_service).to eq "<li>foo</li>"
    end
  end

  context "with row nodes" do
    let(:string) { "<row>foo</row>" }

    it "replace thme with tr" do
      expect(call_service).to eq "<tr>foo</tr>"
    end
  end

  context "with cell nodes" do
    let(:string) { "<cell>foo</cell>" }

    it "replace thme with td" do
      expect(call_service).to eq "<td>foo</td>"
    end
  end

  context "with list and items" do
    let(:string) { "<list rend='ul'><item>foo</item></list>" }

    it "replace them with ul list" do
      expect(call_service).to eq "<ul><li>foo</li></ul>"
    end
  end
end

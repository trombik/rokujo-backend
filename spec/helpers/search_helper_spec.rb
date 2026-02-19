require "rails_helper"

RSpec.describe SearchHelper, type: :helper do
  describe "#operators_from" do
    context "when nil is given" do
      it "returns empty result" do
        expect(helper.operators_from(nil)).to eq({ site_names: [], urls: [] })
      end
    end

    context "when no operator is found in word" do
      it "returns empty result" do
        word = "foo"
        expect(helper.operators_from(word)).to eq({ site_names: [], urls: [] })
      end
    end

    context "when a site_name is found" do
      it "returns one site_names" do
        word = "foo site_name: site1"
        expect(helper.operators_from(word)[:site_names]).to eq(["site1"])
      end
    end

    context "when multiple site_name are found" do
      it "returns all site_names" do
        word = "foo site_name: site1 site_name: site2"
        expect(helper.operators_from(word)[:site_names]).to eq(%w[site1 site2])
      end
    end

    context "when a site name is quoted" do
      it "returns unquoted site_name" do
        word = "foo site_name:\"site 1\""
        expect(helper.operators_from(word)[:site_names]).to eq(["site 1"])
      end
    end

    context "when quoted and unquoted site_names are given" do
      it "returns unquoted site_names" do
        word = "foo site_name:\"site 1\" site_name: site2"
        expect(helper.operators_from(word)[:site_names]).to eq(["site 1", "site2"])
      end
    end

    context "when no url is given" do
      it "returns no urls" do
        word = "foo site_name:\"site 1\" site_name: site2"
        expect(helper.operators_from(word)[:urls]).to eq([])
      end
    end

    context "when a url is given" do
      it "returns a url" do
        word = "foo site_name:\"site 1\" site_name: site2 url: foo"
        expect(helper.operators_from(word)[:urls]).to eq(["foo"])
      end
    end

    context "when multiple urls are given" do
      it "returns urls" do
        word = "foo site_name:\"site 1\" site_name: site2 url: foo url: bar"
        expect(helper.operators_from(word)[:urls]).to eq(%w[foo bar])
      end
    end

    it "extracts operators" do
      word = "foo site_name: site1 site_name: \"site 2\" url: url1 url: url2"
      expected = { site_names: ["site1", "site 2"], urls: %w[url1 url2] }
      expect(helper.operators_from(word)).to eq expected
    end
  end
end

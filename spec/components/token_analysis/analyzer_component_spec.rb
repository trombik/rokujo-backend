# frozen_string_literal: true

require "rails_helper"

RSpec.describe TokenAnalysis::AnalyzerComponent, type: :component do
  let(:component) { described_class.new("こんにちは", [{}]) }

  describe "#pos_color" do
    it "returns text color class" do
      expect(component.pos_color("NOUN")).to be_a String
    end
  end

  describe "#extract_from_morph" do
    it "extract Inflection value from morph" do
      morph = "Inflection=サ行変格;連用形-一般|Reading=シ"
      expect(component.extract_from_morph(morph, "Inflection")).to eq "サ行変格;連用形-一般"
    end

    it "extract Reading value from morph" do
      morph = "Inflection=サ行変格;連用形-一般|Reading=シ"
      expect(component.extract_from_morph(morph, "Reading")).to eq "シ"
    end
  end
end

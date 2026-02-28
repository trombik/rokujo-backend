# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::SingleNumberComponent, type: :component do
  let(:component) { described_class.new(10) }

  describe "#frame_url" do
    it "raises NotImplementedError" do
      expect { component.frame_url }.to raise_error NotImplementedError
    end
  end

  describe "#frame_id" do
    it "is generated from the class name" do
      expect(component.frame_id).to eq "stats_single_number_component"
    end
  end

  describe "#data_text" do
    it "returns 10 as a string" do
      expect(component.data_text).to eq "10"
    end

    context "when data is nil" do
      let(:component) { described_class.new(nil) }

      it "returns `?`" do
        expect(component.data_text).to eq "?"
      end
    end

    context "when data is a big number" do
      let(:component) { described_class.new(10_000_000_000) }

      it "humanize the number" do
        expect(component.data_text).to eq "10 Billion"
      end
    end
  end
end

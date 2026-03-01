# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::MetricByDimensionRowComponent, type: :component do
  let(:label) { "Label" }
  let(:value) { 100 }
  let(:component) { described_class.new(label: label, value: value) }

  before do
    render_inline component
  end

  it "renders label and value" do
    expect(page).to have_text(label).and have_text(value)
  end

  context "when value is a string" do
    let(:value) { "String" }

    it "accepts the string nad renders it" do
      value = "String"

      expect(page).to have_text(value)
    end
  end

  context "when total is given" do
    let(:component) { described_class.new(label: label, value: value, total: 1000) }

    it "renders a percentage of the value" do
      expect(page).to have_text(/\d%/)
    end
  end

  context "when total is given but the value is not a number" do
    let(:value) { "string" }
    let(:component) { described_class.new(label: label, value: value, total: 1000) }

    it "does not render percentage" do
      expect(page).to have_no_text("%")
    end
  end

  context "when value is nil" do
    let(:value) { nil }

    it "renders NaN" do
      expect(page).to have_text("NaN")
    end
  end
end

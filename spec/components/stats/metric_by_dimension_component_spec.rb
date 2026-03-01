# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::MetricByDimensionComponent, type: :component do
  let(:data) do
    [
      { label: "1.example.org", value: "one thing" },
      { label: "2.example.org", value: "another thing" }
    ]
  end
  let(:component) { described_class.new(id: "my_id", metric: "My metric", dimension: "My dimension") }
  let(:section_testid_css) { "[data-testid='section']" }
  let(:header_testid_css) { "[data-testid='header']" }
  let(:rows_testid_css) { "[data-testid='rows']" }

  before do
    render_inline component
  end

  it "has a section" do
    expect(page).to have_css(section_testid_css)
  end

  it "renders a section with the ID" do
    expect(page).to have_css("#{section_testid_css}#my_id")
  end

  it "has a header" do
    expect(page).to have_css(header_testid_css)
  end

  specify "the header includes metric and dimension" do
    within header_testid_css do
      expect(page).to have_text("My metric").and have_text("My dimension")
    end
  end

  it "has a slot for rows" do
    expect(page).to have_css(rows_testid_css)
  end

  it "has labels in `rows` slot" do
    within rows_testid_css do
      expect(page).to have_text("1.example.org").and have_text("2.example.org")
    end
  end

  it "has values in `rows` slot" do
    within rows_testid_css do
      expect(page).to have_text("one thing").and have_text("another thing")
    end
  end
end

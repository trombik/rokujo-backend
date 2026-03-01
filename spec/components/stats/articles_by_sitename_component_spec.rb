# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::ArticlesBySitenameComponent, type: :component do
  let(:data) do
    {
      "foo" => 10_000,
      "bar" => 10
    }
  end
  let(:total) { 10_010 }
  let(:component) { described_class.new(data, total: total) }

  before do
    render_inline component
  end

  it "has turbo_frame" do
    expect(page).to have_css("turbo-frame[data-testid='frame']")
  end

  it "renders labels" do
    expect(page).to have_text("foo").and have_text("bar")
  end

  it "renders values" do
    expect(page).to have_text("10,000").and have_text("10")
  end
end

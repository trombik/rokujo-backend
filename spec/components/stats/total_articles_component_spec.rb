# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::TotalArticlesComponent, type: :component do
  it "renders a comma-delimited number" do
    render_inline described_class.new(1001)

    expect(page).to have_content("1,001")
  end

  context "when the number is big" do
    it "renders the number for human" do
      render_inline described_class.new(10_000_000_000)

      expect(page).to have_content("10 Billion")
    end
  end

  context "when the number is negative" do
    it "renders ? as the number" do
      render_inline described_class.new(-1)

      expect(page).to have_content("?")
    end
  end
end

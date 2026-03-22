# frozen_string_literal: true

require "rails_helper"

RSpec.describe Layout::SectionGridComponent, type: :component do
  let(:cols_per_row) { 4 }
  let(:n_items) { 10 }
  let(:component) { described_class.new(cols_per_row: cols_per_row) }

  before do
    render_inline component do |c|
      c.with_header(data: { testid: "header" }) { "Header" }
      1.upto(n_items) do |i|
        c.with_col do
          "Col#{i}"
        end
      end
    end
  end

  it "renders correct numbers of rows" do
    n_rows = (n_items / cols_per_row) + (n_items % cols_per_row > 0 ? 1 : 0)
    expect(page).to have_css("div.row", count: n_rows)
  end

  it "renders correct number of items" do
    expect(page).to have_css("div.col", count: n_items)
  end

  specify "the first row has cols_per_row cols" do
    within page.first("div.row") do
      expect(page).to have_css("div.col", count: cols_per_row)
    end
  end

  it "renders a header" do
    expect(page).to have_testid("header")
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::SentenceAnalysisRatioComponent, type: :component do
  it "renders the unit as `%`" do
    render_inline described_class.new(100)

    expect(page).to have_content(/100\s+%/)
  end

  it "rounds up the number" do
    render_inline described_class.new(99.55)

    expect(page).to have_content(/99\.6\s+%/)
  end

  it "rounds down the number" do
    render_inline described_class.new(99.54)

    expect(page).to have_content(/99\.5\s+%/)
  end
end

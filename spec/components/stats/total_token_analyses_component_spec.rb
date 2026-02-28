# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::TotalTokenAnalysesComponent, type: :component do
  it "renders the unit as `tokens`" do
    render_inline described_class.new(1001)

    expect(page).to have_content(/1,001\s+tokens/)
  end
end

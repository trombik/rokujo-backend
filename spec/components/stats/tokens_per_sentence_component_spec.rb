# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::TokensPerSentenceComponent, type: :component do
  it "renders the unit as `tokens`" do
    render_inline described_class.new(100)

    expect(page).to have_content(/100\s+tokens/)
  end
end

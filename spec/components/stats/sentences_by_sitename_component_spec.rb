# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::SentencesBySitenameComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline component
  end

  it "has turbo_frame" do
    expect(page).to have_css("turbo-frame[data-testid='frame']")
  end
end

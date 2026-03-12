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

  it "generates the same frame_id" do
    data = [
      { "name" => 1 }
    ]
    with_data = described_class.new(data)
    without_data = described_class.new(nil)

    expect(with_data.frame_id).to eq without_data.frame_id
  end
end

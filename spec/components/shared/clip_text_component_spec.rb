# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ClipTextComponent, type: :component do
  let(:component) { described_class.new(text: text) }
  let(:text) { "foo bar" }

  before do
    render_inline component
  end

  it "has a copy icon" do
    expect(page).to have_css("i.bi-copy")
  end
end

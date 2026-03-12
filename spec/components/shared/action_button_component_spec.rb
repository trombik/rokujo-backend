# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ActionButtonComponent, type: :component do
  let(:component) { described_class.new(icon: icon, text: text) }
  let(:icon) { "copy" }
  let(:text) { "Copy" }

  before do
    render_inline component
  end

  it "renders text" do
    expect(page).to have_text text
  end

  it "renders icon" do
    expect(page).to have_css("i.bi-#{icon}")
  end

  context "when no arguments given" do
    let(:component) { described_class.new }

    it "defaults to copy" do
      expect(page).to have_css("i.bi-copy")
    end
  end
end

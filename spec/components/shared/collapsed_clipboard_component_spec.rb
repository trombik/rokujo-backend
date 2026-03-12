# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::CollapsedClipboardComponent, type: :component do
  let(:component) { described_class.new(label: label, value: value, icon: icon) }
  let(:label) { "A label" }
  let(:value) { "A value" }
  let(:icon) { "clipboard" }

  before do
    render_inline component
  end

  it "has an icon and a label" do
    expect(page).to have_css("i.bi-#{icon}").and have_text(label)
  end
end

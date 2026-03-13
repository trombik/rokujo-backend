# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::ToastFrameComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline component
  end

  it "has ID" do
    expect(page).to have_css("div[id]")
  end

  context "when multiple instances are created" do
    it "does not change the id" do
      expect(component.id).to eq described_class.new.id
    end
  end
end

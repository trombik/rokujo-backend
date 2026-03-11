# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::ToastComponent, type: :component do
  let(:component) { described_class.new(title: title, message: message, type: type) }
  let(:message) { "Message" }
  let(:title) { "Title" }
  let(:type) { nil }

  before do
    render_inline component
  end

  it "renders title and message" do
    expect(page).to have_text(title).and have_text(message)
  end

  it "has toast header and body" do
    expect(page).to have_css("div.toast-header").and have_css("div.toast-body")
  end

  it "has a button to close the toast" do
    expect(page).to have_button class: "btn-close"
  end

  context "with type success" do
    let(:type) { "success" }

    it "uses type as color for title" do
      expect(page).to have_css("div.toast-header.text-#{type}")
    end
  end
end

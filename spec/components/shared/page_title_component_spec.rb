# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::PageTitleComponent, type: :component do
  let(:component) { described_class.new(title: title) }
  let(:title) { "Page title" }

  before do
    render_inline component
  end

  it "renders the title" do
    expect(page).to have_text title
  end

  context "with options" do
    let(:component) { described_class.new(title: title, class: "foo") }

    it "accepts options" do
      expect(page).to have_css("h1.foo")
    end
  end
end

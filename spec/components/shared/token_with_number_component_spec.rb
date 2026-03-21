# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::TokenWithNumberComponent, type: :component do
  let(:component) { described_class.new(text: "foo", number: 123) }

  it "renders the text and the number" do
    render_inline component

    expect(page).to have_text("123").and have_text("foo")
  end

  context "with a block" do
    let(:content) { "Content" }

    before do
      render_inline component do
        content
      end
    end

    it "renders the block and ignores text" do
      expect(page).to have_text(content).and have_no_text("foo")
    end
  end

  context "with blank text" do
    let(:component) { described_class.new(text: "") }

    it "does not render the component" do
      render_inline component

      expect(rendered_content).to eq ""
    end
  end
end

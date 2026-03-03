# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::CollapsibleHelpComponent, type: :component do
  let(:component) { described_class.new("demo") }
  let(:button) { component.button_component }

  it "renders contents of demo.en.md" do
    render_inline component

    expect(page).to have_text("Demo help")
  end

  describe "#button_component" do
    it "renders a button to open the help" do
      render_inline component.button_component

      expect(page).to have_button(class: "btn")
    end
  end

  context "when the markdown file cannot be found" do
    it "raises RuntimeError (only when env is local, not production)" do
      expect do
        render_inline described_class.new("no-such-file")
      end.to raise_error RuntimeError
    end
  end
end

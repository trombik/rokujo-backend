# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::FileUploadComponent, type: :component do
  let(:component) { described_class.new }

  context "with default controller" do
    before do
      render_inline component
    end

    it "renders the component" do
      expect(page).to have_component(component.class)
    end

    it "has a submit button" do
      expect(page).to have_testid "submit"
    end

    it "has a file input field" do
      expect(page).to have_field("Files", type: "file")
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::SiteNameCorrectionsComponent, type: :component do
  let(:resource) { create(:site_name_correction) }

  describe ".new" do
    it "does not rise error" do
      expect { described_class.new(resource) }.not_to raise_error
    end
  end

  context "when an existing resource is being edited" do
    specify "the content contains `Editing`" do
      render_inline described_class.new(resource)

      expect(rendered_content).to have_content("Editing")
    end
  end

  context "when a new resource is being created" do
    let(:resource) { build(:site_name_correction) }

    specify "the content contains `Creating`" do
      render_inline described_class.new(resource)

      expect(rendered_content).to have_content("Creating")
    end
  end
end

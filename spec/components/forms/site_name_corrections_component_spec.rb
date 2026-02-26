# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::SiteNameCorrectionsComponent, type: :component do
  let(:resource) { create(:site_name_correction) }

  describe ".new" do
    it "does not rise error" do
      expect { described_class.new(resource) }.not_to raise_error
    end
  end
end

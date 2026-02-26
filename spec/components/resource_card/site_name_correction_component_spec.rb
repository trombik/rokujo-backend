# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceCard::SiteNameCorrectionComponent, type: :component do
  let(:resource) { create(:site_name_correction) }

  describe "#render?" do
    context "when a resource is given" do
      it "returns true" do
        expect(described_class.new(resource).render?).to be true
      end
    end

    context "when no resource is given" do
      it "returns true" do
        expect(described_class.new(nil).render?).to be false
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::SiteDeleteButtonComponent, type: :component do
  let(:component) { described_class.new(site_name) }
  let(:site_name) { "foo" }

  before do
    render_inline component
  end

  it "includes site_name in button text" do
    expect(page).to have_text(site_name)
  end

  context "when site_name is empty" do
    let(:site_name) { "" }

    it "does not render anything" do
      expect(rendered_content).to eq ""
    end
  end

  context "when site_name is nil" do
    let(:site_name) { nil }

    it "does not render anything" do
      expect(rendered_content).to eq ""
    end
  end
end

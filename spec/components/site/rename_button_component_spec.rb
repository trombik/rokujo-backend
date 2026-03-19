# frozen_string_literal: true

require "rails_helper"

RSpec.describe Site::RenameButtonComponent, type: :component do
  let(:component) { described_class.new(site_name) }
  let(:site_name) { "" }
  let(:article) { create(:article, url: "http://example.org/path", site_name: "foo") }

  before do
    render_inline component
  end

  it "renders a link to create SiteNameCorrection" do
    expect(page).to have_link(href: new_site_name_correction_path(params: { domain: "" }))
  end

  context "with site_name" do
    let(:site_name) { article.site_name }

    it "generates a link with host name from the first matching article" do
      expect(page).to have_link(href: new_site_name_correction_path(params: { domain: "example.org" }))
    end
  end

  context "with url" do
    let(:component) { described_class.new(site_name, url: "http://example.net/path") }

    it "generates a link with host name from the given url" do
      expect(page).to have_link(href: new_site_name_correction_path(params: { domain: "example.net" }))
    end
  end
end

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
    expect(page).to have_link(href: /#{new_site_name_correction_path}/)
  end

  context "with site_name" do
    let(:site_name) { article.site_name }

    it "generates a link with host name from the first matching article" do
      link = page.find_link
      uri = Addressable::URI.parse(link[:href])
      expect(uri.query_values).to include("domain" => "example.org", "name" => "foo")
    end
  end

  context "with url" do
    let(:component) { described_class.new(site_name, url: "http://example.net/path") }

    it "generates a link with host name from the given url" do
      link = page.find_link
      uri = Addressable::URI.parse(link[:href])
      expect(uri.query_values).to include("domain" => "example.net")
    end
  end

  context "with on_success" do
    let(:component) { described_class.new(on_success: "redirect") }

    it "generates a link with on_success query parameter" do
      link = page.find_link
      uri = Addressable::URI.parse(link[:href])
      expect(uri.query_values).to include("on_success" => "redirect")
    end
  end
end

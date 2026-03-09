# frozen_string_literal: true

require "rails_helper"

RSpec.describe Badge::BaseComponent, type: :component do
  let(:resource) { create(:collection_tag) }
  let(:component) { described_class.new(resource) }

  before do
    render_inline component
  end

  it "has the default icon" do
    expect(page).to have_css("i.bi-exclamation-circle")
  end

  it "has a link to the resource" do
    expect(page).to have_link(href: polymorphic_path(resource))
  end

  it "renders resource.name" do
    expect(page).to have_text(resource.name)
  end

  context "when the resource is not saved" do
    let(:resource) { build(:collection_tag) }

    it "has a link and the link has the default path, `#`" do
      expect(page).to have_link(href: "#")
    end
  end

  context "when the resource is nil" do
    let(:resource) { nil }

    it "redners nothing" do
      expect(rendered_content).to eq ""
    end
  end

  context "when link: false is given" do
    let(:component) { described_class.new(resource, link: false) }

    it "has no link to the resouce" do
      expect(page).to have_no_link
    end
  end
end

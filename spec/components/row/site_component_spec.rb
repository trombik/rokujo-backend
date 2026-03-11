# frozen_string_literal: true

require "rails_helper"

RSpec.describe Row::SiteComponent, type: :component do
  let(:component) { described_class.new(site: site) }
  let(:site) do
    tag = create(:collection_tag, name: "Tag")
    collection = create(:article_collection, key: "site_name", value: "Site name", name: "Site name collection")
    collection.collection_tags << tag

    {
      name: "Site name",
      count: 123,
      collection: collection
    }
  end

  before do
    render_inline component
  end

  it "has a <li> with id" do
    expect(page).to have_css("li##{component.id}")
  end

  it "has a link to the site page" do
    expect(page).to have_link("Site name", href: sites_show_path("Site name"))
  end

  it "has a article_collection badge" do
    expect(page).to have_text "Site name collection"
  end

  it "has a collection_tag" do
    expect(page).to have_text "Tag"
  end
end

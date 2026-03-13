# frozen_string_literal: true

require "rails_helper"

RSpec.describe Site::TagGroupComponent, type: :component do
  let(:article) { create(:article) }
  let(:site_name) { article.site_name }
  let(:collection) { create(:article_collection, key: "site_name", value: article.site_name) }
  let(:component) { described_class.new(site_name: site_name, collection: collection) }

  before do
    render_inline component
  end

  it "generates unique id" do
    another_component = described_class.new(site_name: "foo", collection: [])

    expect(component.id).not_to eq another_component.id
  end

  it "renders one Article::CollectionBadgeComponent" do
    expect(page).to have_testid_starting_with Article::CollectionBadgeComponent.testid_prefix, count: 1
  end

  it "does not render Forms::ArticleCollectionButtonComponent" do
    expect(page).to have_no_testid_starting_with(Forms::ArticleCollectionButtonComponent.testid_prefix)
  end

  context "when the site has no ArticleCollection" do
    let(:collection) { [] }

    it "does not render ArticleCollection::CollectionBadgeComponent" do
      expect(page).to have_no_testid_starting_with Article::CollectionBadgeComponent.testid_prefix
    end

    it "renders Forms::ArticleCollectionButtonComponent" do
      expect(page).to have_testid_starting_with(Forms::ArticleCollectionButtonComponent.testid_prefix)
    end
  end

  it "does not render Badge::CollectionBadgeComponent" do
    expect(page).to have_no_testid_starting_with(Badge::CollectionTagComponent.testid_prefix)
  end

  context "when the collection for the site is tagged" do
    before do
      tag = create(:collection_tag)
      collection.collection_tags << tag
      render_inline component
    end

    it "renders Badge::CollectionBadgeComponent" do
      expect(page).to have_testid_starting_with(Badge::CollectionTagComponent.testid_prefix)
    end
  end
end

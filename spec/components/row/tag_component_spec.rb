# frozen_string_literal: true

require "rails_helper"

RSpec.describe Row::TagComponent, type: :component do
  let(:article) { create(:article, site_name: "Site name") }
  let(:component) { described_class.new(tag) }
  let(:article_collection) { create(:article_collection, article.site_name) }
  let(:tag) { create(:collection_tag, article_collections: [article_collection]) }

  it "renders the tag" do
    within "div.row" do
      expect(page).to have_component Badge::CollectionTagComponent
    end
  end

  it "renders the collections tagged with the tag" do
    within "div.row" do
      expect(page).to have_testid(Article::CollectionBadgeComponent.new(article_collection).testid, count: 1)
    end
  end
end

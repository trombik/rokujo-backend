# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article::CollectionBadgeComponent, type: :component do
  let(:article_collection) { create(:article_collection, name: "Name") }
  let(:component) { described_class.new(article_collection) }

  before do
    render_inline component
  end

  it "renders name" do
    expect(page).to have_text(article_collection.name)
  end

  it "has a link to the resource" do
    expect(page).to have_link(article_collection.name)
  end
end

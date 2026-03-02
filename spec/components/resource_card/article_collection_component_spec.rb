# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceCard::ArticleCollectionComponent, type: :component do
  let(:article_collection) { create(:article_collection) }
  let(:component) { described_class.new(article_collection) }

  it "renders name, key, and value" do
    render_inline component

    expect(page).to have_text(article_collection.name)
      .and have_text(article_collection.key)
      .and have_text(article_collection.value)
  end
end

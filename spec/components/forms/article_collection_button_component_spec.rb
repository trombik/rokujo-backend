# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::ArticleCollectionButtonComponent, type: :component do
  let(:article_collection) { build(:article_collection, key: "site_name") }
  let(:component) { described_class.new(article_collection) }

  before do
    render_inline component
  end

  it "renders hidden inputs for name" do
    expect(page).to have_field("article_collection[name]", type: "hidden", with: article_collection.name)
  end

  it "renders hidden inputs for key" do
    expect(page).to have_field("article_collection[key]", type: "hidden", with: article_collection.key)
  end

  it "renders hidden inputs for value" do
    expect(page).to have_field("article_collection[value]", type: "hidden", with: article_collection.value)
  end

  context "when an article_collection with the same key and value exists" do
    it "does not render anything" do
      create(:article_collection, key: article_collection.key, value: article_collection.value)
      render_inline component

      expect(rendered_content).to eq ""
    end
  end

  context "when name is empty" do
    let(:article_collection) { build(:article_collection, name: "") }

    it "does not render anything" do
      expect(rendered_content).to eq ""
    end
  end
end

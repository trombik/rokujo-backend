# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::CollectionTagSelectorComponent, type: :component do
  let(:article_collection) { create(:article_collection) }
  let(:component) { described_class.new(article_collection) }

  before do
    create_list(:collection_tag, 2)
    render_inline component
  end

  it "renders two checkboxes" do
    expect(page).to have_field(type: "checkbox", count: 2)
  end

  it "renders two tag names" do
    expect(page).to have_text(/Tag \d+\b/, count: 2)
  end
end

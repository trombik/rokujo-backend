# frozen_string_literal: true

require "rails_helper"

RSpec.describe Badge::CollectionTagGroupComponent, type: :component do
  let(:tags) { create_list(:collection_tag, 2) }
  let(:collection) { create(:article_collection, collection_tags: tags) }
  let(:component) { described_class.new(collection) }

  before do
    render_inline component
  end

  context "when no collections given" do
    before do
      render_inline described_class.new(nil)
    end

    it "does not render anything" do
      expect(rendered_content).to eq ""
    end
  end

  context "when a collection tagged with two tags is given" do
    it "renders two Badge::CollectionTagComponent" do
      expect(page).to have_testid_starting_with(Badge::CollectionTagComponent::TEST_ID_PREFIX, count: 2)
    end
  end
end

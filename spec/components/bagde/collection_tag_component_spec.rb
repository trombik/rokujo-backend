# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bagde::CollectionTagComponent, type: :component do
  let(:resource) { create(:collection_tag) }
  let(:component) { described_class.new(resource) }

  before do
    render_inline component
  end

  it "has a tag icon" do
    expect(page).to have_css("i.bi-tag-fill")
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::CollectArticlesComponent, type: :component do
  let(:component) { described_class.for(spider) }
  let(:spider) { "read-more" }

  before do
    render_inline component
  end

  it "renders spider name" do
    expect(page).to have_content(spider)
  end

  it "has a hidden input with the spider name as a value" do
    expect(page).to have_field("spider", type: "hidden", with: spider)
  end

  it "has an input for urls" do
    expect(page).to have_field("urls", type: "text")
  end
end

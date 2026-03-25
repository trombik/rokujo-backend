# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article::DropdownActionComponent, type: :component do
  let(:component) { described_class.new(article) }
  let(:article) { create(:article) }

  before do
    render_inline component
  end

  it "renders the component with testid" do
    expect(page).to have_component described_class
  end

  it "renders a button to toggle the dropdown" do
    expect(page).to have_button class: "dropdown-toggle"
  end

  it "has a button to delete the article" do
    expect(page).to have_button text: "Delete"
  end
end

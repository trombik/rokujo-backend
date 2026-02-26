# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceCard::ArticleComponent, type: :component do
  let(:component) { described_class.new(article) }
  let(:link_icon_class) { "i.bi-link-45deg" }
  let(:article) do
    create(:article,
           url: "https://example.org/page.html",
           title: "Title")
  end

  before do
    render_inline(component)
  end

  context "when the article does not have a source" do
    it "does not render a link icon" do
      expect(page).to have_no_css(link_icon_class)
    end
  end

  context "when the article has a source" do
    let(:article) { create(:article, :with_sources) }

    it "renders a link icon" do
      expect(page).to have_css(link_icon_class)
    end
  end

  it "renders domain" do
    expect(page).to have_content("example.org")
  end

  it "renders title" do
    expect(page).to have_content("Title")
  end
end

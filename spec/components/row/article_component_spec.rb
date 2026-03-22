# frozen_string_literal: true

require "rails_helper"

RSpec.describe Row::ArticleComponent, type: :component do
  let(:component) { described_class.new(article: article) }
  let(:article) { create(:article, site_name: site_name, url: url) }
  let(:site_name) { "Site name" }
  let(:url) { "http://example.org/path" }

  before do
    render_inline component
  end

  it "has testid" do
    expect(page).to have_css("[data-testid]")
  end

  it "has id" do
    expect(page).to have_css("div##{component.id}")
  end

  context "when creating multiple components" do
    it "does not generate the same id" do
      another_article = create(:article)
      another_component = described_class.new(article: another_article)

      expect(component.id).not_to eq another_component.id
    end
  end

  it "does not say it has a source" do
    expect(page).to have_no_testid("has_source")
  end

  context "when the article has a source" do
    let(:article) { create(:article, :with_sources) }

    it "says it has a source" do
      expect(page).to have_testid("has_source")
    end
  end

  it "has a link to the article" do
    expect(page).to have_link(href: articles_show_path(uuid: article.uuid))
  end

  it "has a link to the original url" do
    expect(page).to have_link(href: article.url)
  end

  context "when the article does not have site_name" do
    let(:site_name) { nil }

    it "displays normalized URL for reference" do
      expect(page).to have_text(article.normalized_url)
    end
  end
end

require "rails_helper"

RSpec.describe "/articles", :js, type: :system do
  let(:path) { articles_index_path }

  it "displays a list of all articles" do
    create_list(:article, 2)
    visit path

    expect(page).to have_component(Row::ArticleComponent, count: 2)
  end

  context "with site_name param is given" do
    let(:path) { articles_index_path(site_name: "foo") }

    it "displays articles from the site_name" do
      create(:article, site_name: "foo")
      create(:article, site_name: "bar")
      visit path

      expect(page).to have_component(Row::ArticleComponent, count: 1)
    end
  end
end

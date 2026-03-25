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

  context "when clicking delete button" do
    it "destroys the article and remove the article from the list" do
      article = create(:article)
      article_component = Row::ArticleComponent.new(article: article)
      visit path

      expect(page).to have_testid(article_component.testid)
      within find_by_testid(article_component.testid) do
        expect(page).to have_component(Article::DropdownActionComponent)
        click_button class: "dropdown-toggle"
        accept_confirm do
          click_button "submit-delete"
        end
      end
      expect(page).to have_no_testid(article_component.testid)
      expect(Article.count).to be_zero
    end
  end
end

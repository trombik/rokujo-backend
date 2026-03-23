require "rails_helper"

RSpec.describe "/article_collections/", :js, type: :system do
  let(:path) { article_collections_path }

  it "displays a list of all articles" do
    article = create(:article)
    tag = create(:collection_tag, name: "My tag")
    create(:article_collection, value: article.site_name)
    visit path

    expect(page).to have_component(ResourceCard::ArticleCollectionComponent, count: 1)

    within find_component(ResourceCard::ArticleCollectionComponent, match: :first) do
      # as the collection has not been tagged yet, there should not be any
      # tags
      expect(page).to have_no_component(Badge::CollectionTagComponent)

      within find_component(Forms::CollectionTagSelectorComponent, match: :first) do
        # open the selector and tag the collection
        click_button class: "dropdown-toggle"
        expect(page).to have_unchecked_field(tag.name)
        check tag.name
        click_button "submit"
        click_button class: "dropdown-toggle"
      end
      expect(page).to have_component(Badge::CollectionTagGroupComponent)
      within find_component(Badge::CollectionTagGroupComponent, match: :first) do
        expect(page).to have_text tag.name
      end
    end
  end
end

require "rails_helper"

RSpec.describe "/sites/index", :js, type: :system do
  describe "adding an article collection flow" do
    before do
      create(:article, site_name: "Test site")
      visit sites_index_path
    end

    context "when the site has no article collection" do
      it "renders `Create a collection` button and the button disappears after clicking the button" do
        within find_component(Row::SiteComponent) do
          within find_component(Site::TagGroupComponent) do
            # before clicking, there is no collection badge
            expect(page).to have_no_component(Article::CollectionBadgeComponent)

            expect do
              within find_component(Forms::ArticleCollectionButtonComponent) do
                click_button
              end

              # after click_button, Forms::ArticleCollectionButtonComponent
              # disappears.
              expect(page).to have_no_component(Forms::ArticleCollectionButtonComponent)
            end.to change(ArticleCollection, :count).by(1)

            # and the badge appears
            expect(page).to have_component(Article::CollectionBadgeComponent)
          end
        end
      end
    end
  end
end

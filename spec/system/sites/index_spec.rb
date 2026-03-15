require "rails_helper"

RSpec.describe "/sites/index", :js, type: :system do
  let(:site_name) { "Test site" }

  before do
    create(:article, site_name: site_name)
    visit sites_index_path
  end

  describe "adding an article collection flow" do
    context "when the site has no article collection" do
      it "renders `Create a collection` button and the button disappears after clicking the button" do
        within find_component(Row::SiteComponent) do
          within find_component(Site::TagGroupComponent) do
            expect(page).to have_no_component(Article::CollectionBadgeComponent)

            within find_component(Forms::ArticleCollectionButtonComponent) do
              click_button
            end

            expect(page).to have_no_component(Forms::ArticleCollectionButtonComponent)
            expect(page).to have_component(Article::CollectionBadgeComponent)
          end
        end
      end
    end
  end
end

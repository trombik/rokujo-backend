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
        within find_by_testid_starting_with(Row::SiteComponent.testid_prefix) do
          within find_by_testid_starting_with(Site::TagGroupComponent.testid_prefix) do
            expect(page).to have_no_testid_starting_with(Article::CollectionBadgeComponent.testid_prefix)

            within find_by_testid_starting_with(Forms::ArticleCollectionButtonComponent.testid_prefix) do
              click_button
            end

            expect(page).to have_no_testid_starting_with(Forms::ArticleCollectionButtonComponent.testid_prefix)
            expect(page).to have_testid_starting_with(Article::CollectionBadgeComponent.testid_prefix)
          end
        end
      end
    end
  end
end

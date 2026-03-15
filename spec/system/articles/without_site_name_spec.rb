require "rails_helper"

RSpec.describe "/articles/without_site_name", :js, type: :system do
  let(:site_name) { "Test site" }

  before do
    create(:article, site_name: nil)
    visit articles_without_site_name_path
  end

  describe "creating SiteNameCorrection from without_site_name flow" do
    it "allows to create SiteNameCorrection with a modal form", :aggregate_failures do
      within find_by_testid_starting_with(Row::ArticleComponent.testid_prefix) do
        click_on "Create Site Name Correction"
      end

      # expect the modal that contains the form shows up
      expect(page).to have_testid_starting_with(Forms::SiteNameCorrectionsComponent.testid_prefix)

      # expect SiteNameCorrection is created
      within find_by_testid_starting_with(Forms::SiteNameCorrectionsComponent.testid_prefix) do
        fill_in "Name", with: "Foo"
        expect(page).to have_button "Create Site name correction"
        find_by_testid_starting_with("submit").click
      end

      expect(page).to have_css("[data-close]")
      expect(SiteNameCorrection.count).to eq 1
    end
  end
end

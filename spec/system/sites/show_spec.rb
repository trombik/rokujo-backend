require "rails_helper"

RSpec.describe "/sites/index", :js, type: :system do
  let!(:article) { create(:article, site_name: "Site name", url: "http://example.org/path") }

  before do
    visit sites_show_path(article.site_name)
  end

  describe "Create SiteNameCorrection work flow" do
    it "creates SiteNameCorrection" do
      # It has a button to add SiteNameCorrection
      expect(page).to have_component(Site::RenameButtonComponent)

      # No SiteNameCorrection exist before the flow
      expect(SiteNameCorrection.count).to be_zero

      # When the button is clicked
      find_component(Site::RenameButtonComponent).click
      # A form is shown
      expect(page).to have_component(Forms::SiteNameCorrectionsComponent)

      within find_component(Forms::SiteNameCorrectionsComponent) do
        # the form is prefilled with the site attributes
        expect(page).to have_field("Domain", with: Addressable::URI.parse(article.url).host)
        expect(page).to have_field("Name", with: article.site_name)

        fill_in "Name", with: "New site name"
      end

      expect do
        # When the submit button is clicked,
        within find_component(Forms::SiteNameCorrectionsComponent) do
          click_on "submit"
        end
        # The dialog disappears and a SiteNameCorrection is created
        expect(page).to have_no_component(Forms::SiteNameCorrectionsComponent)
      end.to change(SiteNameCorrection, :count).by(1)

      # the browser is redirected to the new site_name page
      expect(page).to have_content("New site name")
      expect(page).to have_current_path sites_show_path("New site name")
    end

    context "when a SiteNameCorrection exists" do
      let!(:site_name_correction) do
        create(:site_name_correction, domain: Addressable::URI.parse(article.url).host, name: "New site name")
      end

      it "reuses the site_name_correction for the form and redirects the browser after submittion" do
        expect(page).to have_component(Site::RenameButtonComponent)

        find_component(Site::RenameButtonComponent).click
        expect(page).to have_component(Forms::SiteNameCorrectionsComponent)

        within find_component(Forms::SiteNameCorrectionsComponent) do
          expect(page).to have_field("Name", with: site_name_correction.name)
          expect(page).to have_field("Domain", with: site_name_correction.domain)
        end

        expect do
          within find_component(Forms::SiteNameCorrectionsComponent) do
            fill_in "Name", with: "Another new site name"
            click_on "submit"
          end
          expect(page).to have_no_component(Forms::SiteNameCorrectionsComponent)
        end.not_to change(SiteNameCorrection, :count)
        expect(page).to have_current_path sites_show_path("Another new site name")
      end
    end

    context "when the form is filled with invalid values" do
      it "keeps the form open" do
        expect(page).to have_component(Site::RenameButtonComponent)

        find_component(Site::RenameButtonComponent).click
        expect(page).to have_component(Forms::SiteNameCorrectionsComponent)

        within find_component(Forms::SiteNameCorrectionsComponent) do
          fill_in "Name", with: ""
          click_on "submit"
          expect(page).to have_component(Forms::ValidationErrorComponent)
        end
        expect(page).to have_component(Forms::SiteNameCorrectionsComponent)
      end
    end
  end
end

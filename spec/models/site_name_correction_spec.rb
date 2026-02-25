require "rails_helper"

RSpec.describe SiteNameCorrection, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:domain) }
    it { is_expected.to validate_presence_of(:name) }

    describe "uniqueness" do
      subject { create(:site_name_correction) }

      it { is_expected.to validate_uniqueness_of(:domain) }
    end
  end

  describe "after_save: apply_correction_to_articles" do
    let(:domain) { "example.org" }
    let(:correct_name) { "Corrected site_name" }

    let!(:target_article) { create(:article, url: "https://#{domain}/news/1", site_name: nil) }
    let!(:other_article) { create(:article, url: "https://other.example.com/news/1", site_name: "Other site") }

    context "when an article is created" do
      it "updates site_name of the article" do
        expect do
          create(:site_name_correction, domain: domain, name: correct_name)
          target_article.reload
        end.to change(target_article, :site_name).to(correct_name)
      end

      it "does not update other article" do
        expect do
          create(:site_name_correction, domain: domain, name: correct_name)
          other_article.reload
        end.not_to change(other_article, :site_name)
      end
    end

    context "when a SiteNameCorrection is updated" do
      let!(:correction) { create(:site_name_correction, domain: domain, name: "old name") }

      it "updates site_name of existing articles with new site_name" do
        target_article.update!(site_name: "old name")

        expect do
          correction.update!(name: "new name")
          target_article.reload
        end.to change(target_article, :site_name).to("new name")
      end
    end
  end
end

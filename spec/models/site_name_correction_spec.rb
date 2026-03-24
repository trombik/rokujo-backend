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

  describe "after_save hooks" do
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

  describe "#apply_correction_to_articles" do
    context "when more than one records to update and limit is 1" do
      let(:number_of_articles) { 2 }
      let(:site_name_correction) do
        # create site_name_correction before creating articles to avoid
        # after_commit hook
        site_name_correction = create(:site_name_correction, name: "New site name", domain: "example.org")
        create_list(:article, number_of_articles)
        site_name_correction
      end

      it "updates one record" do
        site_name_correction.apply_correction_to_articles(limit: 1)

        expect(Article.where(site_name: site_name_correction.name).count).to eq 1
      end

      it "enqueues ApplySiteNameCorrectionJob" do
        expect do
          site_name_correction.apply_correction_to_articles(limit: 1)
        end.to have_enqueued_job(ApplySiteNameCorrectionJob).exactly(:once)
      end

      context "when limit is nil (default)" do
        it "udpates all articles at once" do
          site_name_correction.apply_correction_to_articles(limit: nil)

          expect(Article.where(site_name: site_name_correction.name).count).to eq number_of_articles
        end

        it "does not enqueue ApplySiteNameCorrectionJob" do
          expect do
            site_name_correction.apply_correction_to_articles(limit: nil)
          end.not_to have_enqueued_job(ApplySiteNameCorrectionJob)
        end
      end
    end
  end
end

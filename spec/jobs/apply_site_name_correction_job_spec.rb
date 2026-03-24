require "rails_helper"

RSpec.describe ApplySiteNameCorrectionJob, type: :job do
  let(:site_name_correction) { create(:site_name_correction) }

  it "applies corrections" do
    allow(site_name_correction).to receive(:apply_correction_to_articles).and_return true
    allow(SiteNameCorrection).to receive(:find).with(site_name_correction.id).and_return(site_name_correction)
    described_class.perform_now(site_name_correction.id)

    expect(site_name_correction).to have_received(:apply_correction_to_articles)
  end

  context "when SiteNameCorrection is not found" do
    it "silently discards the job" do
      expect do
        described_class.perform_now(256)
      end.not_to raise_error
    end
  end
end

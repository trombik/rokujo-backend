# A job to rename site_name with the given SiteNameCorrection.
class ApplySiteNameCorrectionJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(id)
    site_name_correction = SiteNameCorrection.find(id)
    site_name_correction.apply_correction_to_articles
  end
end

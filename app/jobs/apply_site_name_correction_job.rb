# A job to rename site_name with the given SiteNameCorrection.
class ApplySiteNameCorrectionJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  include NotificationHelper

  def perform(id)
    site_name_correction = SiteNameCorrection.find(id)
    site_name_correction.apply_correction_to_articles
    broadcast_toast(
      title: ApplySiteNameCorrectionJob.to_s,
      message: "Finished renaming all articles to #{site_name_correction.name}"
    )
  end
end

# A model to override Article's site_name. Useful when Articles do not have
# site_name.
class SiteNameCorrection < ApplicationRecord
  validates :domain, presence: true, uniqueness: true
  validates :name,   presence: true

  # when creating SiteNameCorrection from sites#show, the browser is
  # redirected to new site name page. apply SiteNameCorrection to some
  # articles so that the controller finds the new site name. otherwise, the
  # new site cannot be found by the controller because there might be no
  # article with the new site name. apply_minimal_correction limits the number
  # of articles to update to reasonable numbers so that the request would not
  # timeout.
  after_commit :apply_minimal_correction, on: [:create, :update]

  def apply_correction_to_articles(limit: nil)
    Article.url_like(domain)
           .limit(limit)
           .find_each do |article|
      article.site_name = name
      article.save
    end
    enqueue_bulk_correction
  end

  def enqueue_bulk_correction
    ApplySiteNameCorrectionJob.perform_later(id) if Article.url_like(domain).where.not(site_name: name).exists?
  end

  private

  def apply_minimal_correction
    # if at least one article with new name exists, taht is enough for the redirection
    # to work.
    return if Article.exists?(site_name: name)

    apply_correction_to_articles(limit: 1_000)
  end
end

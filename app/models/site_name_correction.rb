# A model to override Article's site_name. Useful when Articles do not have
# site_name.
class SiteNameCorrection < ApplicationRecord
  validates :domain, presence: true, uniqueness: true
  validates :name,   presence: true

  after_save :apply_correction_to_articles

  private

  def apply_correction_to_articles
    escaped_domain = self.class.sanitize_sql_like(domain)

    # what if the pattern matches millions of records? create a job to update
    # records.
    Article.where("normalized_url LIKE ?", "#{escaped_domain}%").find_each do |article|
      article.update(site_name: name)
    end
  end
end

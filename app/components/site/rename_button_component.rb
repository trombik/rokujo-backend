# frozen_string_literal: true

# a button to creste SiteNameCorrection
class Site::RenameButtonComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent
  include ERB::Util

  def initialize(site_name = "", url: "", on_success: "")
    @site_name = site_name
    @url = url
    @on_success = on_success
    super()
  end

  private

  attr_reader :site_name, :url, :on_success

  def domain
    return Addressable::URI.parse(url).host if url.present?
    return "" if site_name.blank?

    article = Article.by_site_name(site_name).first

    return "" if article.blank?

    Addressable::URI.parse(article.url).host
  rescue Addressable::URI::InvalidURIError
    ""
  end
end

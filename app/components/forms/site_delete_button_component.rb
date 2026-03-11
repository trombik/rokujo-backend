# frozen_string_literal: true

# Button to delete all the articles and article_collections from a site
class Forms::SiteDeleteButtonComponent < ViewComponent::Base
  def initialize(site_name)
    @site_name = site_name
    super()
  end

  attr_reader :site_name

  def render?
    site_name.present?
  end
end

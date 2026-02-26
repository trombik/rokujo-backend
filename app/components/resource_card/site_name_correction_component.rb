# frozen_string_literal: true

# A card to display SiteNameCorrection
class ResourceCard::SiteNameCorrectionComponent < ViewComponent::Base
  attr_reader :site_name_correction

  def initialize(site_name_correction)
    @site_name_correction = site_name_correction
    super()
  end

  def render?
    site_name_correction.present?
  end
end

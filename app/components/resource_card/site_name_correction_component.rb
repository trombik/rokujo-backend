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

  def card_wrapper_classes
    "card border rounded-3 mb-3 shadow-sm bg-light"
  end
end

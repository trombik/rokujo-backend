# frozen_string_literal: true

# A form component to create and edit SiteNameCorrection
class Forms::SiteNameCorrectionsComponent < ViewComponent::Base
  attr_reader :site_name_correction

  def initialize(site_name_correction)
    @site_name_correction = site_name_correction
    super()
  end
end

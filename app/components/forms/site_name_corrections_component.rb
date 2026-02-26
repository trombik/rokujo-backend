# frozen_string_literal: true

# A form component to create and edit SiteNameCorrection
class Forms::SiteNameCorrectionsComponent < ViewComponent::Base
  attr_reader :site_name_correction

  def initialize(site_name_correction)
    @site_name_correction = site_name_correction
    super()
  end

  def title_string
    mode = site_name_correction.persisted? ? "edit" : "create"
    t(".title.#{mode}", model_name: site_name_correction.model_name.human)
  end
end

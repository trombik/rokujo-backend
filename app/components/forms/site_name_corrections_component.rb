# frozen_string_literal: true

# A form component to create and edit SiteNameCorrection
class Forms::SiteNameCorrectionsComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(site_name_correction, on_success: nil)
    @site_name_correction = site_name_correction
    @on_success = on_success
    super()
  end

  private

  attr_reader :site_name_correction, :on_success

  def title_string
    mode = site_name_correction.persisted? ? "edit" : "create"
    t(".title.#{mode}", model_name: site_name_correction.model_name.human)
  end

  def help_for_name
    Forms::CollapsibleHelpComponent.new("site_name_correction_name",
                                        help_class: "card card-body shadow-sm")
  end

  def help_for_domain
    Forms::CollapsibleHelpComponent.new("site_name_correction_domain",
                                        help_class: "card card-body shadow-sm")
  end

  # NOTE: Forced scrollable configuration for Turbo-powered modals.  When
  # modal content is dynamically updated via Turbo Streams or contains
  # collapsible elements, Bootstrap's internal height calculations for
  # ".modal-dialog-scrollable" fails to trigger correctly.
  def scrollable_workaround_style
    "overflow-y: auto; max-height: calc(100vh - 200px);"
  end

  def turbo_frame
    "_top" if on_success == "redirect"
  end
end

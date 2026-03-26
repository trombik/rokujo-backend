# frozen_string_literal: true

# Modal cotent for forms
class Shared::ModalFormComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  renders_one :title
  renders_one :body
  renders_one :submit_button

  private

  def uniq_key
    "not_uniq"
  end

  # NOTE: Forced scrollable configuration for Turbo-powered modals.  When
  # modal content is dynamically updated via Turbo Streams or contains
  # collapsible elements, Bootstrap's internal height calculations for
  # ".modal-dialog-scrollable" fails to trigger correctly.
  def scrollable_workaround_style
    "overflow-y: auto; max-height: calc(100vh - 200px);"
  end
end

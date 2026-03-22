# frozen_string_literal: true

# A shared, dynamic modal
class Shared::ModalComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def target_id
    "target_#{id}"
  end

  def frame_id
    "frame_#{id}"
  end

  # @return sanitized HTML tag to close the modal dialog.
  def close
    sanitize(tag.span(data: { close: true }), attributes: ["data-close"])
  end

  # as this component is always available on every pages and shared by other
  # components, the id is not unique.
  def uniq_key
    "not_uniq"
  end
end

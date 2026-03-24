# frozen_string_literal: true

# A frame to display ToastComonent
class Notification::ToastFrameComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  delegate :stream_id, to: self

  def self.stream_id
    "global_notifications"
  end

  private

  def uniq_key
    ""
  end
end

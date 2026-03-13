# frozen_string_literal: true

# A frame to display ToastComonent
class Notification::ToastFrameComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def uniq_key
    ""
  end
end

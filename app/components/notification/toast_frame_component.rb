# frozen_string_literal: true

# A frame to display ToastComonent
class Notification::ToastFrameComponent < ViewComponent::Base
  def id
    self.class.name.gsub("::", "_").underscore
  end
end

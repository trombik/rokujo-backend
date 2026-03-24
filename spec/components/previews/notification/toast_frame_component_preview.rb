# frozen_string_literal: true

class Notification::ToastFrameComponentPreview < ViewComponent::Preview
  def default
    render Notification::ToastFrameComponent.new
  end
end

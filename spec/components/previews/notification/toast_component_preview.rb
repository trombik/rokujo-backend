# frozen_string_literal: true

class Notification::ToastComponentPreview < ViewComponent::Preview
  # @!group
  def default
    title = "Info"
    message = "Hello, world!"
    render Notification::ToastComponent.new(title: title, message: message, autohide: false)
  end

  def success
    title = "Success"
    type = :success
    message = "It worked!"
    render Notification::ToastComponent.new(title: title, message: message, type: type, autohide: false)
  end

  def failed
    title = "Error"
    type = :danger
    message = "It failed!"
    render Notification::ToastComponent.new(title: title, message: message, type: type, autohide: false)
  end
  # @!endgroup
end

# frozen_string_literal: true

# A toast notification.
class Notification::ToastComponent < ViewComponent::Base
  attr_reader :message, :title, :type, :autohide

  def initialize(message:, title: "Message", type: :primary, autohide: true)
    @message = message
    @title = title
    @type = type
    @autohide = autohide
    super()
  end
end

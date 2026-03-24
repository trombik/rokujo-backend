# frozen_string_literal: true

# A toast notification.
class Notification::ToastComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(message:, title: "Message", type: :primary, autohide: true, delay: 10 * 1000)
    @message = message
    @title = title
    @type = type
    @autohide = autohide
    @delay = delay
    super()
  end

  private

  attr_reader :message, :title, :type, :autohide, :delay
end

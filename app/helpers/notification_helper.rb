# Helpers to send notifications
module NotificationHelper
  # Send a global toast notification.
  def broadcast_toast(...)
    frame = Notification::ToastFrameComponent.new
    Turbo::StreamsChannel.broadcast_append_to(
      frame.stream_id,
      target: frame.id,
      html: ApplicationController.render(
        Notification::ToastComponent.new(...),
        layout: false
      )
    )
  end
end

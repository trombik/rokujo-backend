# Job to collect articles
class CollectArticlesJob < ApplicationJob
  queue_as :default

  rescue_from(Exception) do |exception|
    broadcast_toast(
      title: self.class.name,
      message: "Failed to collect articles (#{exception.class.name}).",
      autohide: false
    )
    Rails.error.report(exception)
    raise exception
  end

  include NotificationHelper

  # Run CollectArticlesService
  #
  # @param spider_name [String] the name of the spider to run
  # @param arg [Hash] A hash of spider's arguments
  def perform(spider_name, arg)
    service = CollectArticlesService.new(spider_name, arg) do
      SolidQueue::Process.current.heartbeat if defined?(SolidQueue::Process) && SolidQueue::Process.current
    end

    file, status = service.call
    log_and_raise(spider_name, service, arg) unless status.success?
    enqueue_job(file)
    broadcast_toast(
      title: self.class.name,
      message: "Articles have been successfully collected."
    )
  end

  private

  def enqueue_job(file)
    ImportFileJob.perform_later(file.to_s)
  end

  def log_and_raise(spider_name, service, arg)
    Rails.logger.error { "#{self.class.name}: #{spider_name}: Failed" }
    details = { spider_name: spider_name,
                arg: arg,
                stdout: service.stdout,
                stderr: service.stderr }
    raise details.to_s
  end
end

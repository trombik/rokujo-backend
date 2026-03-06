# Job to collect articles
class CollectArticlesJob < ApplicationJob
  queue_as :default

  rescue_from(Exception) do |exception|
    Rails.error.report(exception)
    raise exception
  end

  # Run CollectArticlesService
  #
  # @param spider_name [String] the name of the spider to run
  # @param arg [Hash] A hash of spider's arguments
  def perform(spider_name, arg)
    service = CollectArticlesService.new(spider_name, arg)
    file, status = service.call
    unless status.success?
      Rails.logger.error { "#{self.class.name}: #{spider_name}: Failed" }
      details = { spider_name: spider_name,
                  arg: arg,
                  stdout: service.stdout,
                  stderr: service.stderr }
      raise details.to_s
    end
    Rails.logger.info { "#{self.class.name}: #{spider_name}: Success" }
  ensure
    FileUtils.rm file if file
  end
end

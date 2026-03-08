require "rokujo/extractor"
require "timeout"

# Job to extract articles from a JSONL file, filter sentences in the article,
# and enqueue the result.
class ExtractArticlesJob < ApplicationJob
  class FileNotFoundError < StandardError; end
  class EmptyFileError < StandardError; end
  class ParserError < StandardError; end
  class EnqueueError < StandardError; end

  queue_as :default

  rescue_from(Exception) do |exception|
    Rails.error.report(exception)
    raise exception
  end

  # @param file [String] Path to the file
  def perform(file)
    # ActiveRecord::Base.connection_pool.release_connection
    raise_if_file_has_issues(file)
    File.foreach(file).with_index do |line, index|
      Rails.logger.info "Processing line #{index}" if (index % 10).zero?
      hashed_item = extract_hashed_item_from_line(line)
      next unless hashed_item

      enqueued_job = ImportArticleJob.perform_later(hashed_item)
      raise EnqueueError, "Failed to enqueue ImportArticleJob for line: #{line}" unless enqueued_job
    end
  end

  private

  def extract_hashed_item_from_line(line)
    # ActiveRecord::Base.connection_pool.release_connection
    parser = Rokujo::Extractor::Parsers::Article.new(line, widget_enable: false)
    Rails.logger.info { "extract_sentences" }
    Timeout.timeout(300) do
      parser.extract_sentences
      Rails.logger.info { "extract_sentences finished" }
    end
    parser.item.to_h
  rescue Timeout::Error
    Rails.logger.error { "extract_sentences timed out" }
    nil
  rescue StandardError
    raise ParserError
  end

  def raise_if_file_has_issues(file)
    raise FileNotFoundError, "File does not exist: #{file}" unless File.exist?(file)
    raise EmptyFileError, "File is empty: #{file}" if File.empty?(file)
  end
end

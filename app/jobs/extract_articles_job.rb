require "rokujo/extractor"
require "timeout"

# Job to extract articles from a JSONL file, filter sentences in the article,
# and enqueue the result. The job is queued in analysis queue because
# Rokujo::Extractor::Parsers::Article calls the remote spacy analysis server.
class ExtractArticlesJob < ApplicationJob
  class FileNotFoundError < StandardError; end
  class EmptyFileError < StandardError; end
  class EnqueueError < StandardError; end

  queue_as :analysis

  rescue_from(Exception) do |exception|
    Rails.error.report(exception)
    raise exception
  end

  # @param file [String] Path to the file
  def perform(file)
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
    parser = Rokujo::Extractor::Parsers::Article.new(line, widget_enable: false)
    Timeout.timeout(300) do
      parser.extract_sentences
    end
    parser.item.to_h
  rescue Timeout::Error
    Rails.logger.error { "extract_sentences timed out" }
    nil
  end

  def raise_if_file_has_issues(file)
    raise FileNotFoundError, "File does not exist: #{file}" unless File.exist?(file)
    raise EmptyFileError, "File is empty: #{file}" if File.empty?(file)
  end
end

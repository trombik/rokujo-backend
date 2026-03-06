require "open3"

# Service to collect articles by running scrapy
#
# This service initializes a scrapy spider, runs it with the specified arguments,
# and saves the output to a file. The service also handles logging and error
# checking.
#
# @example
#   service = CollectArticlesService.new("example_spider", { "arg1" => "value1" })
#   output_file, status = service.call
#   content = output_file.read
#
class CollectArticlesService < ApplicationService
  # The path to scrapy repository
  WORK_DIR = Rails.root.join("vendor/rokujo-collector-scrapy-generic")
  # the directory to keep collected files
  OUTPUT_DIR = Rails.root.join("tmp/downloads/articles")
  # format of the output file.
  OUTPUT_FORMAT = "jsonl".freeze

  # Initializes a new instance of CollectArticlesService
  #
  # @param spider_name [String] the name of the spider to run
  # @param args [Hash] the arguments to pass to the spider
  # @param loglevel [Symbol] the log level for scrapy (default: :info)
  # @param output_dir [String, Pathname] the directory to save the output files (default: OUTPUT_DIR)
  # @param format [String] the file format of the output file.
  def initialize(spider_name, args, loglevel: :info, output_dir: OUTPUT_DIR, format: OUTPUT_FORMAT)
    super()
    @spider_name = spider_name
    @args = args
    @loglevel = loglevel
    @format = format
    @output_dir = Pathname.new(output_dir)
  end

  # Runs the scrapy spider and saves the output to a file
  #
  # When the command fails, output_file is nil.
  #
  # @return [Array] an array containing the output file path and the status of the command
  #
  # @example
  #   service = CollectArticlesService.new("example_spider", { "arg1" => "value1" })
  #   output_file, status = service.call
  #   status
  #   # => #<Process::Status: pid 77537 exit 0>
  #   status.success?
  #   # => true
  def call
    prepare
    @tmp_file = Tempfile.create(self.class.name)
    @tmp_file.close
    run
  ensure
    FileUtils.rm_f(@tmp_file.path)
  end

  private

  attr_reader :args,
              :format,
              :output_dir,
              :spider_name

  # Runs the scrapy command and returns the output, error, and status
  #
  # @return [Array] an array containing the output, error, and status of the command
  def run
    Rails.logger.debug { "cmd: #{build_cmd}" }

    out, err, status = Dir.chdir(WORK_DIR) { Open3.capture3(*build_cmd) }
    log_result(out, err, status)
    if status.success?
      FileUtils.mv(@tmp_file.path, output_file)
      [output_file, status]
    else
      [nil, status]
    end
  end

  # Logs the output and error of the scrapy command
  #
  # @param out [String] the standard output of the command
  # @param err [String] the standard error of the command
  # @param status [Process::Status] the status of the command
  def log_result(out, err, status)
    Rails.logger.info(out)
    Rails.logger.error(err) unless status.success?
  end

  def build_cmd
    raise "BUG: @tmp_file is not set" unless @tmp_file

    [
      "uv", "run",
      "scrapy", "crawl",
      "--loglevel=#{loglevel}",
      "-O", "#{@tmp_file.path}:#{format}",
      spider_args,
      spider_name
    ].flatten
  end

  def spider_args
    args.map { |k, v| "#{k}=#{v}" }.map { |arg| ["-a", arg] }.flatten
  end

  def output_file
    return @output_file if @output_file

    timestamp = Time.zone.now.strftime("%Y%m%dT%H_%M_%S")
    random_char = SecureRandom.hex(8)
    @output_file = output_dir.join("articles_#{timestamp}_#{random_char}.jsonl")
  end

  def loglevel
    @loglevel.to_s.upcase
  end

  def prepare
    FileUtils.mkdir_p output_dir
    raise RuntimeError, "#{output_dir} is not writable." unless output_dir.writable?
    raise RuntimeError, "required scrapy repository cannot be found: #{WORK_DIR}" unless WORK_DIR.exist?
  end
end

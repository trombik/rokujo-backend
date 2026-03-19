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

  attr_reader :stdout, :stderr

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
    @stdout = ""
    @stderr = ""
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
  def call(&)
    prepare
    @tmp_file = Tempfile.create(self.class.name)
    @tmp_file.close
    run(&)
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
  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def run(&block)
    Rails.logger.debug { "cmd: #{build_cmd}" }
    status = Open3.popen3(*build_cmd, chdir: WORK_DIR.to_s) do |_in, out, err, wait_thr|
      thr_out = Thread.new do
        while (line = out.gets)
          @stdout << line
          block&.call
        end
      end
      thr_err = Thread.new do
        while (line = err.gets)
          @stderr << line
          block&.call
        end
      end
      thr_out.join
      thr_err.join
      wait_thr.value
    end

    if status.success?
      FileUtils.mv(@tmp_file.path, output_file)
      [output_file, status]
    else
      [nil, status]
    end
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize

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
    args.compact_blank
        .map { |k, v| "#{k}=#{v}" }
        .map { |arg| ["-a", arg] }
        .flatten
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
    raise "#{output_dir} is not writable." unless output_dir.writable?
    raise "required scrapy repository cannot be found: #{WORK_DIR}" unless WORK_DIR.exist?
  end
end

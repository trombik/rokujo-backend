# Job to import uploaded files
class ImportFileJob < ApplicationJob
  class Error < StandardError; end
  class UnsupportedFileError < Error; end
  class FileTooBigError < Error; end
  class UnknownFileError < Error; end

  queue_as :default

  SUPPORTED_FILE_TYPE = %w[.jsonl .docx .pdf].freeze
  MEGA_BYTES = 1024 * 1024
  GIGA_BYTES = 1024 * MEGA_BYTES
  MAX_FILE_BYTES = 1 * GIGA_BYTES

  def perform(file)
    file = Pathname.new(file) unless file.is_a?(Pathname)
    raise_if_unacceptable!(file)
    extractor = extractor_for(file)
    raise UnknownFileError, "file name: #{file.realpath}" unless extractor

    enqueue_job(file, extractor)
  end

  def enqueue_job(file, extractor)
    case extractor.name
    when Rokujo::Extractor::Parsers::Article.name
      ExtractArticlesJob.perform_later(file.to_s)
    else
      ExtractFileJob.perform_later(file.to_s, extractor.name)
    end
  end

  def raise_if_unacceptable!(file)
    raise Errno::ENOENT unless file.exist?
    raise UnsupportedFileError unless SUPPORTED_FILE_TYPE.include? file.extname

    case file.extname
    when ".docx", ".pdf"
      raise FileTooBigError, "file name: #{file.realpath}, size: #{file.size}" if file.size > MAX_FILE_BYTES
    end
  end

  def extractor_for(file)
    case Marcel::MimeType.for file
    when "application/pdf"
      return Rokujo::Extractor::Parsers::PDF
    when "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      return Rokujo::Extractor::Parsers::Docx
    end
    Rokujo::Extractor::Parsers::Article if file.extname == ".jsonl"
  end
end

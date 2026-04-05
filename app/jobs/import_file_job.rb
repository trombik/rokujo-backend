# import a JSONL file and enqueue ImportArticleJob with each line
class ImportFileJob < ApplicationJob
  queue_as :default

  retry_on SQLite3::BusyException

  discard_on Errno::ENOENT

  def perform(file)
    File.open(file) do |f|
      f.each_line do |line|
        hash = JSON.parse(line)
        ImportArticleJob.perform_later(hash)
      rescue JSON::ParserError
        next
      end
    end
  end
end

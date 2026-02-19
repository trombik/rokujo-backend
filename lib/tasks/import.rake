require "json"

namespace :import do
  desc "Import articles and sentences from a JSONL file"
  task :jsonl, [:path] => :environment do |_t, args|
    path = args[:path]
    if path.nil? || !File.exist?(path)
      puts "Usage: bin/rails \"import:jsonl[path/to/data.jsonl]\""
      exit
    end

    puts "Importing from #{path}..."

    File.open(path, "r") do |file|
      file.each_line.with_index(1) do |line, index|
        hash = JSON.parse(line)
        Article.import_from_hash!(hash)
        print "." if (index % 100).zero?
      end
    end

    puts "\nImport completed. Enqueuing analysis jobs..."
    EnqueueTokenAnalysisJob.perform_later
  end
end

require "json"

namespace :import do # rubocop:disable Metrics/BlockLength
  desc "Import articles and sentences from a JSONL file"
  task :jsonl, [:path] => :environment do |_t, args| # rubocop:disable Metrics/BlockLength
    path = args[:path]
    if path.nil? || !File.exist?(path)
      puts "Usage: bin/rails \"import:jsonl[path/to/data.jsonl]\""
      exit
    end

    puts "Importing from #{path}..."
    File.open(path) do |f|
      f.each_line do |line|
        article_hash = JSON.parse(line)
        sentence_texts = article_hash.delete("sentences")
        token_groups = article_hash.delete("tokens")

        article = Article.create!(article_hash)

        Article.transaction do
          sentences = sentence_texts.map.with_index do |text, index|
            article.sentences.build(line_number: index, text: text)
          end
          article.save!

          sentences.each_with_index do |sentence, index|
            tokens_for_line = token_groups[index]
            next unless tokens_for_line

            tokens_for_line.each do |token_attr|
              sentence.token_analyses.build(token_attr)
            end
            sentence.save!
          end
        end
      end
    end
  end
end

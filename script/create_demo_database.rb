require_relative "../config/environment"

raise "Set RAILS_ENV to demo" unless Rails.env.demo?

initial_articles_json_file = Rails.root.join("db/articles/initial_articles.jsonl")
File.open(initial_articles_json_file) do |f|
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

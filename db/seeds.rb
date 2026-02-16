# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"

model = Spacy::Language.new("ja_ginza")

File.foreach("tmp/test.jsonl") do |line|
  hash = JSON.parse(line)
  begin
    article = Article.import_from_hash!(hash)
    article.sentences.each do |sentence|
      sentence.analyze_and_store_pos!(model)
    end
  rescue StandardError => e
    Rails.logger.error "Failed to import_from_hash: #{hash}"
    raise e
  end
end

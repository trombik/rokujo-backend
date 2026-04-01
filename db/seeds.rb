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
require "shellwords"

# re-create db/initial_articles.jsonl
def fetch_initial_articles
  script = Rails.root.join("script/fecth_initial_articles.rb")
  system "ruby #{script.to_s.shellescape} > #{initial_articles_jsonl.to_s.shellescape}"
end

# tha path to file from which we import artciles.
def initial_articles_jsonl
  Rails.root.join("db/articles/initial_articles.jsonl")
end

if Rails.env.development?
  fetch_initial_articles unless initial_articles_jsonl.exist?
  raise "#{fetch_initial_articles} does not exist" unless initial_articles_jsonl.exist?

  # disable :debug logs during import for faster import
  saved_log_level = Rails.logger.level
  Rails.logger.level = :info

  initial_articles_jsonl.each_line do |line|
    item = JSON.parse(line)
    # a faster check to validate artciles
    next if Article.exists?(url: item["url"])

    Article.import_from_hash!(item)
  rescue ActiveRecord::RecordNotUnique
    next
  end

  # rename site_name
  SiteNameCorrection.where(domain: "ja.wikipedia.org", name: "Wikipedia").first_or_create.apply_correction_to_articles
  SiteNameCorrection.where(domain: "www.yamdas.org", name: "YAMDAS").first_or_create.apply_correction_to_articles
  SiteNameCorrection.where(domain: "genpaku.org", name: "Project Genpaku").first_or_create.apply_correction_to_articles

  # create ArticleCollection for each site_name. they are tagged later
  yamdas_collection = ArticleCollection.where(key: "site_name", name: "YAMDAS", value: "YAMDAS").first_or_create
  wikipedia_colection = ArticleCollection.where(key: "site_name", name: "Wikipedia", value: "Wikipedia").first_or_create
  novel_collection = ArticleCollection.where(key: "site_name", name: "星空文庫", value: "星空文庫").first_or_create

  # this one is not tagged
  ArticleCollection.where(key: "site_name", name: "Project Genpaku", value: "Project Genpaku").first_or_create

  # create tags
  tag = CollectionTag.where(name: "novel").first_or_create
  tag.article_collections << novel_collection unless tag.article_collections.include? novel_collection

  tag = CollectionTag.where(name: "formal").first_or_create
  tag.article_collections << wikipedia_colection unless tag.article_collections.include? wikipedia_colection

  tag = CollectionTag.where(name: "tech").first_or_create
  tag.article_collections << yamdas_collection unless tag.article_collections.include? yamdas_collection

  # restore the log level
  Rails.logger.level = saved_log_level
end

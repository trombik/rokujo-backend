# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_19_131958) do
  create_table "article_sources", force: :cascade do |t|
    t.string "article_id", null: false
    t.datetime "created_at", null: false
    t.string "source_article_id", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "source_article_id"], name: "index_article_sources_on_article_id_and_source_article_id", unique: true
  end

  create_table "articles", primary_key: "uuid", id: :string, force: :cascade do |t|
    t.datetime "acquired_time"
    t.string "author"
    t.text "body"
    t.integer "character_count"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "item_type"
    t.string "kind"
    t.string "lang"
    t.string "location"
    t.datetime "modified_time"
    t.string "normalized_url"
    t.datetime "published_time"
    t.json "raw_json"
    t.string "site_name"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["normalized_url"], name: "index_articles_on_normalized_url"
    t.index ["site_name"], name: "index_articles_on_site_name"
    t.index ["url"], name: "index_articles_on_url", unique: true
  end

  create_table "sentences", force: :cascade do |t|
    t.json "analysis_data"
    t.string "article_uuid", null: false
    t.datetime "created_at", null: false
    t.integer "line_number", null: false
    t.text "search_tokens"
    t.text "text"
    t.datetime "updated_at", null: false
    t.index ["article_uuid"], name: "index_sentences_on_article_uuid"
  end

  create_table "token_analyses", force: :cascade do |t|
    t.string "article_uuid", null: false
    t.datetime "created_at", null: false
    t.string "dep"
    t.integer "end"
    t.integer "head"
    t.string "lemma"
    t.integer "line_number", null: false
    t.string "morph"
    t.string "pos"
    t.integer "start"
    t.string "tag", null: false
    t.string "text"
    t.integer "token_id"
    t.datetime "updated_at", null: false
    t.index ["article_uuid", "line_number"], name: "index_token_analyses_on_article_uuid_and_line_number"
    t.index ["lemma"], name: "index_token_analyses_on_lemma"
  end

  add_foreign_key "article_sources", "articles", column: "source_article_id", primary_key: "uuid"
  add_foreign_key "article_sources", "articles", primary_key: "uuid"
  add_foreign_key "sentences", "articles", column: "article_uuid", primary_key: "uuid"
end

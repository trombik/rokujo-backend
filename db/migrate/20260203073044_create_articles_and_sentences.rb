class CreateArticlesAndSentences < ActiveRecord::Migration[8.1]
  def change
    id_type = connection.adapter_name =~ /postgresql/i ? :uuid : :string
    create_table :articles, id: false do |t|
      t.column :uuid, id_type, null: false, primary_key: true
      t.string :url
      t.string :title
      t.text :description
      t.datetime :acquired_time
      t.datetime :modified_time
      t.datetime :published_time
      t.string :site_name
      t.text :body
      t.json :raw_json
      t.string :location
      t.string :author
      t.string :lang
      t.string :kind
      t.string :item_type
      t.integer :character_count

      t.timestamps
    end

    create_table :sentences do |t|
      t.column :article_uuid, id_type, null: false
      t.text :text
      t.integer :line_number, null: false
      t.json :analysis_data
      t.text :search_tokens

      t.primary_key [:article_uuid, :line_number]
      t.timestamps
    end
    add_index :articles, :url, unique: true
    add_index :sentences, :article_uuid
    add_foreign_key :sentences, :articles, column: :article_uuid, primary_key: :uuid
  end
end

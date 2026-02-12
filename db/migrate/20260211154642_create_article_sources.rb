class CreateArticleSources < ActiveRecord::Migration[8.1]
  def change
    create_table :article_sources do |t|
      t.string :article_id, null: false
      t.string :source_article_id, null: false

      t.timestamps
    end

    add_foreign_key :article_sources, :articles, column: :article_id, primary_key: "uuid"
    add_foreign_key :article_sources, :articles, column: :source_article_id, primary_key: "uuid"
    add_index :article_sources, [:article_id, :source_article_id], unique: true
  end
end

class CreateArticleCollections < ActiveRecord::Migration[8.1]
  def change
    create_table :article_collections do |t|
      t.string :name
      t.string :key

      t.timestamps
    end
    add_index :article_collections, :key
  end
end

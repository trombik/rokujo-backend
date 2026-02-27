class AddUniqueIndexToArticleCollection < ActiveRecord::Migration[8.1]
  def change
    add_index :article_collections, :name, unique: true
  end
end

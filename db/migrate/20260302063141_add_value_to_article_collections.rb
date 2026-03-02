class AddValueToArticleCollections < ActiveRecord::Migration[8.1]
  def change
    add_column :article_collections, :value, :string
  end
end

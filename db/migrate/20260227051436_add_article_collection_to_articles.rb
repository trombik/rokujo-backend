class AddArticleCollectionToArticles < ActiveRecord::Migration[8.1]
  def change
    add_reference :articles, :article_collection, null: true, foreign_key: true
  end
end

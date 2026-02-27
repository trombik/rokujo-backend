class CreateArticleCollectionTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :article_collection_taggings do |t|
      t.references :article_collection, null: false, foreign_key: true
      t.references :collection_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

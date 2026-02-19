class AddNormalizedUrlToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :normalized_url, :string
    add_index :articles, :normalized_url
  end
end

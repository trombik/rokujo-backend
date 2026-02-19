class AddIndexToArticlesSiteName < ActiveRecord::Migration[8.1]
  def change
    add_index :articles, :site_name
  end
end

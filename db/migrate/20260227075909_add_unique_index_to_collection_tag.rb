class AddUniqueIndexToCollectionTag < ActiveRecord::Migration[8.1]
  def change
    remove_index :collection_tags, :name
    add_index :collection_tags, :name, unique: true
  end
end

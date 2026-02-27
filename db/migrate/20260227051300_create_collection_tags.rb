class CreateCollectionTags < ActiveRecord::Migration[8.1]
  def change
    create_table :collection_tags do |t|
      t.string :name

      t.timestamps
    end
    add_index :collection_tags, :name
  end
end

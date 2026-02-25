class CreateSiteNameCorrections < ActiveRecord::Migration[8.1]
  def change
    create_table :site_name_corrections do |t|
      t.string :domain, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :site_name_corrections, :domain, unique: true
  end
end

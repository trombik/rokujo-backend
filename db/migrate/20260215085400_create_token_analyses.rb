class CreateTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    create_table :token_analyses do |t|
      t.string :article_uuid, null: false
      t.integer :line_number, null: false

      t.string :dep
      t.string :head_pos
      t.string :head_text
      t.string :lemma
      t.string :pos
      t.string :text
      t.string :tag, null: false

      t.timestamps
    end

    add_index :token_analyses, [:article_uuid, :line_number]
    add_index :token_analyses, :lemma
  end
end

class AddTOkenIdToTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :token_analyses, :token_id, :integer
    add_column :token_analyses, :start, :integer
    add_column :token_analyses, :end, :integer
    add_column :token_analyses, :morph, :string
    remove_column :token_analyses, :head_lemma, :string
    remove_column :token_analyses, :head_pos, :string
    remove_column :token_analyses, :head_tag, :string
    remove_column :token_analyses, :head_text, :string
  end
end

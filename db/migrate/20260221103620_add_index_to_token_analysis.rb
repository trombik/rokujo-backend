class AddIndexToTokenAnalysis < ActiveRecord::Migration[8.1]
  def change
    add_index :token_analyses, :text
    add_index :token_analyses, :pos
  end
end

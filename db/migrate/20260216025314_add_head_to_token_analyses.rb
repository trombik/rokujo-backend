class AddHeadToTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :token_analyses, :head, :integer
  end
end

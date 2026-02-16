class AddHeadTagToTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :token_analyses, :head_tag, :string
  end
end

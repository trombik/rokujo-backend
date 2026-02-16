class AddHeadLemmaToTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    add_column :token_analyses, :head_lemma, :string
  end
end

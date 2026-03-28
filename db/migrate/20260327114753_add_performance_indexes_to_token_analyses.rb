class AddPerformanceIndexesToTokenAnalyses < ActiveRecord::Migration[8.1]
  def change
    # 1. ターゲット（修飾される側）を素早く見つけるため
    # 現状の単体インデックスを消して複合にするか、追加する
    add_index :token_analyses, [:lemma, :pos]

    # 2. 依存関係（修飾している側）を爆速で検索するため
    # article_uuid, line_number 内で特定の head を持つトークンを即座に特定する
    add_index :token_analyses, [:article_uuid, :line_number, :head], name: "idx_token_lookup_by_head"

    # 3. (オプション) token_id 自体が頻繁に検索対象（headの比較対象）になるなら
    # もし token_id が主キーでない場合、これが必要
    add_index :token_analyses, :token_id unless index_exists?(:token_analyses, :token_id)
  end
end

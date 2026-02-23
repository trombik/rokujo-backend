# frozen_string_literal: true

class TokenAnalysis::AnalyzerComponentPreview < ViewComponent::Preview
  def default
    render TokenAnalysis::AnalyzerComponent.new(text, tokens)
  end

  private

  def text
    "カスタマイズ可能な独自のホームページを作成し、オンラインで注目を集めましょう。"
  end

  def tokens
    [
      {
        "i" => 0,
        "text" => "カスタマイズ",
        "lemma" => "カスタマイズ",
        "pos" => "NOUN",
        "tag" => "名詞-普通名詞-サ変可能",
        "dep" => "compound",
        "head" => 1,
        "morph" => "Reading=カスタマイズ",
        "idx" => 0
      },
      {
        "i" => 1,
        "text" => "可能",
        "lemma" => "可能",
        "pos" => "ADJ",
        "tag" => "形状詞-一般",
        "dep" => "acl",
        "head" => 5,
        "morph" => "Reading=カノウ",
        "idx" => 6
      },
      {
        "i" => 2,
        "text" => "な",
        "lemma" => "だ",
        "pos" => "AUX",
        "tag" => "助動詞",
        "dep" => "aux",
        "head" => 1,
        "morph" => "Inflection=助動詞-ダ;連体形-一般|Reading=ナ",
        "idx" => 8
      },
      {
        "i" => 3,
        "text" => "独自",
        "lemma" => "独自",
        "pos" => "ADJ",
        "tag" => "形状詞-一般",
        "dep" => "nmod",
        "head" => 5,
        "morph" => "Reading=ドクジ",
        "idx" => 9
      },
      {
        "i" => 4,
        "text" => "の",
        "lemma" => "の",
        "pos" => "ADP",
        "tag" => "助詞-格助詞",
        "dep" => "case",
        "head" => 3,
        "morph" => "Reading=ノ",
        "idx" => 11
      },
      {
        "i" => 5,
        "text" => "ホームページ",
        "lemma" => "ホームページ",
        "pos" => "NOUN",
        "tag" => "名詞-普通名詞-一般",
        "dep" => "obj",
        "head" => 7,
        "morph" => "Reading=ホームページ",
        "idx" => 12
      },
      {
        "i" => 6,
        "text" => "を",
        "lemma" => "を",
        "pos" => "ADP",
        "tag" => "助詞-格助詞",
        "dep" => "case",
        "head" => 5,
        "morph" => "Reading=ヲ",
        "idx" => 18
      },
      {
        "i" => 7,
        "text" => "作成",
        "lemma" => "作成",
        "pos" => "VERB",
        "tag" => "名詞-普通名詞-サ変可能",
        "dep" => "advcl",
        "head" => 14,
        "morph" => "Reading=サクセイ",
        "idx" => 19
      },
      {
        "i" => 8,
        "text" => "し",
        "lemma" => "する",
        "pos" => "AUX",
        "tag" => "動詞-非自立可能",
        "dep" => "aux",
        "head" => 7,
        "morph" => "Inflection=サ行変格;連用形-一般|Reading=シ",
        "idx" => 21
      },
      {
        "i" => 9,
        "text" => "、",
        "lemma" => "、",
        "pos" => "PUNCT",
        "tag" => "補助記号-読点",
        "dep" => "punct",
        "head" => 7,
        "morph" => "Reading=、",
        "idx" => 22
      },
      {
        "i" => 10,
        "text" => "オンライン",
        "lemma" => "オンライン",
        "pos" => "NOUN",
        "tag" => "名詞-普通名詞-一般",
        "dep" => "obl",
        "head" => 14,
        "morph" => "Reading=オンライン",
        "idx" => 23
      },
      {
        "i" => 11,
        "text" => "で",
        "lemma" => "で",
        "pos" => "ADP",
        "tag" => "助詞-格助詞",
        "dep" => "case",
        "head" => 10,
        "morph" => "Reading=デ",
        "idx" => 28
      },
      {
        "i" => 12,
        "text" => "注目",
        "lemma" => "注目",
        "pos" => "NOUN",
        "tag" => "名詞-普通名詞-サ変可能",
        "dep" => "obj",
        "head" => 14,
        "morph" => "Reading=チュウモク",
        "idx" => 29
      },
      {
        "i" => 13,
        "text" => "を",
        "lemma" => "を",
        "pos" => "ADP",
        "tag" => "助詞-格助詞",
        "dep" => "case",
        "head" => 12,
        "morph" => "Reading=ヲ",
        "idx" => 31
      },
      {
        "i" => 14,
        "text" => "集め",
        "lemma" => "集める",
        "pos" => "VERB",
        "tag" => "動詞-一般",
        "dep" => "ROOT",
        "head" => 14,
        "morph" => "Inflection=下一段-マ行;連用形-一般|Reading=アツメ",
        "idx" => 32
      },
      {
        "i" => 15,
        "text" => "ましょう",
        "lemma" => "ます",
        "pos" => "AUX",
        "tag" => "助動詞",
        "dep" => "aux",
        "head" => 14,
        "morph" => "Inflection=助動詞-マス;意志推量形|Reading=マショウ",
        "idx" => 34
      },
      {
        "i" => 16,
        "text" => "。",
        "lemma" => "。",
        "pos" => "PUNCT",
        "tag" => "補助記号-句点",
        "dep" => "punct",
        "head" => 14,
        "morph" => "Reading=。",
        "idx" => 38
      }
    ].map(&:deep_symbolize_keys)
  end
end

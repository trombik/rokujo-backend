FactoryBot.define do
  factory :token_analysis do
    sentence
    article_uuid { sentence.article_uuid }
    line_number { sentence.line_number }

    sequence(:token_id) { |n| n }
    text { "サンプル" }
    lemma { "サンプル" }
    pos { "NOUN" }
    tag { "名詞-一般" }
    dep { "root" }
    head { 0 }
    start { 0 }
    add_attribute(:end) { 4 } # end is a reserved word in ruby
    morph { "PropNoun" }
  end
end

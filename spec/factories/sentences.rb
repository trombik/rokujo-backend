FactoryBot.define do
  factory :sentence do
    article_uuid { "MyString" }
    text { "MyText" }
    line_number { 1 }
    analysis_data { "" }
    search_tokens { "MyText" }
  end
end

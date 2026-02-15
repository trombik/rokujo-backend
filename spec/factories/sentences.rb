FactoryBot.define do
  factory :sentence do
    article
    text { "MyText" }
    sequence(:line_number) { |n| n }
    analysis_data { "" }
    search_tokens { "MyText" }
  end
end

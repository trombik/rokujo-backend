FactoryBot.define do
  factory :sentence do
    article
    text { "MyText" }
    sequence(:line_number) { |n| n }
    analysis_data { "" }
    search_tokens { "MyText" }

    # by default, analyze the text after creation
    transient do
      analyze { true }
    end

    after(:create) do |sentence, context|
      sentence.analyze_and_store_pos! if context.analyze
    end
  end
end

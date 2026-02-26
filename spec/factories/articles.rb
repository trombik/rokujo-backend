FactoryBot.define do
  factory :article do
    uuid { SecureRandom.uuid_v7 }
    sequence(:url) { |n| "https://example#{n}.org/path/#{SecureRandom.uuid_v7}" }
    title { "MyString" }
    description { "MyText" }
    acquired_time { "2026-02-03 14:30:44" }
    modified_time { "2026-02-03 14:30:44" }
    published_time { "2026-02-03 14:30:44" }
    site_name { "MyString" }
    body { "MyText" }
    raw_json { "" }
    location { "MyString" }
    author { "MyString" }
    trait :with_sources do
      after(:build) do |article|
        article.sources << build(:article)
      end
    end
  end
end

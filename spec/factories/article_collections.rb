FactoryBot.define do
  factory :article_collection do
    sequence(:name) { |n| "Site #{n}" }
    key { "site_name" }
    value { "Foo" }
  end
end

FactoryBot.define do
  factory :collection_tag do
    sequence(:name) { |n| "Tag #{n}" }
  end
end

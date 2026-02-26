FactoryBot.define do
  factory :site_name_correction do
    sequence(:domain) { |n| "#{n}.example.org" }
    name { "Corrected name" }
  end
end

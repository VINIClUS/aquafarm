FactoryBot.define do
  factory :farm do
    association :user
    sequence(:name) { |n| "Fazenda #{n}" }
  end
end

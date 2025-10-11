# spec/factories/ponds.rb
FactoryBot.define do
  factory :pond do
    association :farm
    sequence(:name) { |n| "Tanque #{n}" }
    volume { 1200 }
    # se tiver external_id:
    # sequence(:external_id) { |n| "pond-ext-#{n}" }
  end
end

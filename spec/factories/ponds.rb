# spec/factories/ponds.rb
FactoryBot.define do
  factory :farm do
    name { "Fazenda Teste" }
  end

  factory :pond do
    association :farm
    name { "Tanque #{SecureRandom.hex(2)}" }
    volume { 1200 }
  end
end

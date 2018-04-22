# spec/factories/relationships.rb
FactoryBot.define do
  factory :relationship do
    requestor { Faker::Internet.unique.email }
    target    { Faker::Internet.unique.email }
    friend true
    following true
  end
end

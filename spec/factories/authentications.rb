FactoryBot.define do
  factory :authentication do
    provider { 'twitter' }
    uid { random.rand(18) }
    user
  end
end

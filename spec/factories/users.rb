FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name_#{n}" }
    profile_image_url { 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png' }
  end
end

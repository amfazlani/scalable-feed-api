FactoryBot.define do
  factory :post do
    title { "Test post" }
    description { "Hello world" }
    image_url { "https://example.com/image.jpg" }
    association :user
  end
end

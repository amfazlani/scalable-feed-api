# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = 5.times.map do |i|
  User.create!(
    first_name: "User#{i}",
    last_name: "Test",
    email: "user#{i}@test.com",
    password: "password"
  )
end

users.each do |user|
  (users - [ user ]).sample(2).each do |followed|
    Subscription.create!(
      user: user,
      followed_user: followed
    )
  end
end

users.each do |user|
  5.times do |i|
    Post.create!(
      user: user,
      title: "Post #{i} by #{user.first_name}",
      description: "Hello from #{user.first_name}",
      image_url: "https://picsum.photos/300/300?random=#{rand(1000)}"
    )
  end
end

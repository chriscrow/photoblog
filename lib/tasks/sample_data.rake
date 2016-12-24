namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_articles
    make_relationships
  end
  
  def make_users
    User.create!(nickname: "example user",
                  username: "exampleuser@qq.com",
                  password: "foobar",
                  password_confirmation: "foobar",
                  admin: true )
    99.times do |n|
      nickname = Faker::Name.name
      username = "example_#{n+1}@qq.com"
      password = "password"
      
      User.create!(nickname: nickname,
                    username: username,
                    password: password,
                    password_confirmation: password )
    end
  end
  
  def make_articles
    users = User.limit(6)
    30.times do
      content = Faker::Lorem.sentence(50)
      title = Faker::Lorem.sentence(5)
      users.each { |user| user.articles.create!(content:content, title:title) }
    end
  end
  
  def make_relationships
    users = User.all
    user = User.first
    followed_users = users[2..50]
    followers = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
  end
end
  
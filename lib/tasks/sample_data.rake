namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
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
end
  
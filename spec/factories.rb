FactoryGirl.define do
  factory :user do
    username       "chrischen@qq.com"
    nickname       "Chris Chen"
    password       "123456"
    password_confirmation "123456"
  end
end
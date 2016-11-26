FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "person#{n}@qq.com" }
    sequence(:nickname) { |n| "Person #{n}" }
    password       "123456"
    password_confirmation "123456"
    factory :admin do
      admin true
    end
  end
end
# encoding: UTF-8

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Usuario #{n}" }
    sequence(:email) { |n| "usuario_#{n}@example.com"} 
    password "123456"
    password_confirmation "123456"
    ciudad_residencia "Los Realejos"

    factory :admin do
      admin true
    end
  end
end

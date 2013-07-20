# encoding: UTF-8
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end

def make_users
  admin = User.create!(name: "Juan José Labrador González",
                       email: "jjlabradorglez@gmail.com",
                       password: "123456",
                       password_confirmation: "123456",
                       ciudad_residencia: "Los Realejos")
  admin.toggle!(:admin)

  admin = User.create!(name: "Juan Francisco González Ramos",
                       email: "juan.ramos.fg1@gmail.com",
                       password: "123456",
                       password_confirmation: "123456",
                       ciudad_residencia: "Santa Cruz de Tenerife")
  admin.toggle!(:admin)

  98.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@touristfriend.org"
    password  = "password"
    ciudad_residencia = "foobar"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 ciudad_residencia: ciudad_residencia)
  end
end
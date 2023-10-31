# frozen_string_literal: true

# spec/factories.rb
require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { '12345' }
  end
end

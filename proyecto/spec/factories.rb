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

FactoryBot.define do
  factory :question do
    answer { true }
    question { 'Sample question' }
    content_link { '/images/letraE.png' }
    module_id { 1 }
  end
end

FactoryBot.define do
  factory :response do
    user
    question
    answer { true }
  end
end

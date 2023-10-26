# spec/factories.rb
require 'factory_bot'

FactoryBot.define do
    factory :user do
      name { 'Juancito' }
      email { 'juancito@mail.com' }
      password { 'j123' }
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

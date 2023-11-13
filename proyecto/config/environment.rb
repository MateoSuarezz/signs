# frozen_string_literal: true

db_options = YAML.safe_load(File.read('./config/database.yml'))

environment = ENV['APP_ENV'] || 'development'
ActiveRecord::Base.establish_connection(db_options[environment])

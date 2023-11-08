# # frozen_string_literal: true

# require 'sinatra/base'
# require 'bundler/setup'
# require 'logger'
# require 'sinatra/activerecord'
# require 'active_record'
# require 'yaml'
# require_relative 'db/info_loaders/add_game_info'
# require 'simplecov'
# require 'sinatra/reloader' if Sinatra::Base.environment == :development
# Dir['./models/*.rb'].sort.each { |file| require file }

# # App, currently: Is connected to the database.
# class App < Sinatra::Application
#   configure do
#     db_config = YAML.load_file('config/database.yml')
#     ActiveRecord::Base.establish_connection(db_config['development'])

#     set :root, File.dirname(__FILE__)
#     set :views, File.join(root, 'views')
#     set :public_folder, "#{File.dirname(__FILE__)}/public"
#     enable :sessions

#     configure :development do
#       register Sinatra::Reloader
#       enable :logging, :dump_errors, :raise_errors
#     end
#   end

#   configure :production, :development do
#     enable :logging

#     logger = Logger.new($stdout)
#     logger.level = Logger::DEBUG if development?
#     set :logger, logger
#   end

#   def user_logged_in?
#     session[:user_id] != nil
#   end

  



# end

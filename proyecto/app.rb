# frozen_string_literal: true

require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'
require 'active_record'
require 'yaml'
require_relative 'db/info_loaders/add_game_info'
require 'simplecov'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require_relative 'controllers/user_controller'
require_relative 'controllers/game_controller'
Dir['./models/*.rb'].sort.each { |file| require file }

class MyApp < Sinatra::Base
  configure do
    db_config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(db_config['development'])
    set :root, File.dirname(__FILE__)
    set :views, File.join(root, 'views')
    set :public_folder, "#{File.dirname(__FILE__)}/public"
    enable :sessions
  end
  use UserController
  use GameController
  run! if app_file == $PROGRAM_NAME
end

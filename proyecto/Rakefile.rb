require 'sinatra/activerecord/rake'
require 'sinatra'
require 'sinatra/activerecord' # Only if using ActiveRecord

namespace :db do
  task :load_config do
    require "./server"
  end
end


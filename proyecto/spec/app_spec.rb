require 'rack/test'

RSpec.describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    # Include the name of the class corresponding to the Application defined in server.rb
    App
  end

  it 'testing server routes' do
    get '/login' # Access the root route
    expect(last_response.status).to eq(200) # Verify the HTTP response status code
  end
end

require_relative '../../models/init.rb'

describe 'User' do
  describe 'valid' do
    it 'is invalid when there is no name' do
      user = User.new
      expect(user.valid?).to eq(false)
    end

    it 'is invalid with a duplicate email' do
      user = User.create(email: 'test@example.com', password: 'password')

      duplicate_user = User.new(email: 'test@example.com', password: 'another_password')
      
      expect(duplicate_user.valid?).to eq(false)
    end
  end
end



# sudo docker compose exec app bundle exec rspec

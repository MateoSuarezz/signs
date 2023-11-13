# frozen_string_literal: true

require_relative '../../models/init'

describe 'User' do
  describe 'valid' do
    it 'is invalid when there is no name' do
      user = User.new
      expect(user.valid?).to be(false)
    end

    it 'is invalid with a duplicate email' do
      User.create(email: 'test@example.com', password: 'password')

      duplicate_user = User.new(email: 'test@example.com', password: 'another_password')

      expect(duplicate_user.valid?).to be(false)
    end
  end
end

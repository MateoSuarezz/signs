
class User < ActiveRecord::Base
    def authenticate(password)
      self.password == password
    end
    validates :email, presence: true, uniqueness: true
end
  
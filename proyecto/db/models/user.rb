class User < ActiveRecord::Base
    def authenticate(password)
      self.password == password
    end
end
  
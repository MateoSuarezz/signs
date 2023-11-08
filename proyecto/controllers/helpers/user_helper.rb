# helpers/user_helpers.rb
module UserHelper
    def user_logged_in
      session[:user_id] != nil
    end
end
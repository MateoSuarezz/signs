# frozen_string_literal: true

# helpers/user_helpers.rb

# additional methods for user controller
module UserHelper
  def user_logged_in
    !session[:user_id].nil?
  end
end

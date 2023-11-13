# frozen_string_literal: true

# modules model
class Modules < ActiveRecord::Base
  has_many :questions
end

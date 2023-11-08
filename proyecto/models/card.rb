# frozen_string_literal: true

# cards model
class Card < ActiveRecord::Base
  has_one :module
  validates :content_link, presence: true, format: { with: %r{\A/images/} }
  validates :module_id, presence: true
end

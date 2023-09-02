class Question < ActiveRecord::Base
    has_one :module
    validates :answer, presence: true
    validates :question, presence: true
    validates :content_link, presence: true, format: { with: /\A\/images\// }
    validates :module_id, presence: true
  end
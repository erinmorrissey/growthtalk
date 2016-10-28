class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource

  validates :comment_text, presence: true
end

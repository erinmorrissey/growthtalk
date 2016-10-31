class Resource < ActiveRecord::Base
  belongs_to :category
  has_many :comments

  validates :name, presence: true

  ratyrate_rateable 'overall'
end

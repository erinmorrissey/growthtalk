class Category < ActiveRecord::Base
  has_many :resources, dependent: :destroy

  validates :name, presence: true
end

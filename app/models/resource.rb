class Resource < ActiveRecord::Base
  belongs_to :category
  has_many :comments

  validates :name, presence: true

  ratyrate_rateable 'overall'

  include AlgoliaSearch

  algoliasearch per_environment: true do
    attribute :name, :logo_image, :category
  end
end

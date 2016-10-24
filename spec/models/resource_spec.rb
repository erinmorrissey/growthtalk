require 'rails_helper'

RSpec.describe Resource, type: :model do
  it 'is valid with valid attributes' do
    expect(Resource.new(name: 'test resource')).to be_valid
  end

  it 'is not valid without a name' do
    resource = Resource.new(name: nil)
    expect(resource).to_not be_valid
  end
end

require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with valid attributes' do
    expect(Category.new(name: 'test category')).to be_valid
  end

  it 'is not valid without a name' do
    cat = Category.new(name: nil)
    expect(cat).to_not be_valid
  end
end

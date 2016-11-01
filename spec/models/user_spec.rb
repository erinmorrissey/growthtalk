require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is an admin with admin flag set to true' do
    admin = FactoryGirl.create(:admin)
    expect(admin.admin?).to be true
  end
end

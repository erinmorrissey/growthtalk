require 'rails_helper'

describe CategoryPolicy do
  subject { described_class }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  permissions :index?, :show? do
    it 'grants access if user is NOT an admin' do
      expect(subject).to permit(user)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it 'denies access if user is NOT an admin' do
      expect(subject).not_to permit(user)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(admin)
    end
  end
end

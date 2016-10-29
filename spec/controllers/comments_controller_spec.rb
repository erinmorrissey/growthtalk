require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:res) { Resource.create(name: 'test resource', category_id: 57) }

  describe 'comments#create' do
    it 'creates a new comment in the DB' do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user
      post :create, resource_id: res.id, comment: { comment_text: 'test comment' }
      comment = Comment.last
      expect(comment.comment_text).to eq 'test comment'
      expect(comment.resource_id).to eq res.id
      expect(comment.user).to eq(user)
      expect(response).to redirect_to resource_path(res)
    end

    it 'returns a 404 error - if the resource is NOT found' do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user
      post :create, resource_id: 'TACOCAT', comment: { comment_text: 'test comment' }
      expect(response).to have_http_status(:not_found)
    end
  end
end

require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  let(:cat) { FactoryGirl.create(:category) }
  let(:res) { FactoryGirl.create(:resource) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'resources#show' do
    it 'shows the page - if the resource is found' do
      # triggers HTTP GET request to /resources/:id
      get :show, id: res.id
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the resource is NOT found' do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when user is logged in (non-admin)' do
    before do
      sign_in user
    end

    describe 'resources#new' do
      it 'shows the new resource form page' do
        # triggers HTTP GET request to /categories/:category_id/resources/new
        get :new, category_id: cat.id
        expect(response).to have_http_status(:success)
      end
    end

    describe 'resources#create' do
      it 'creates a new resource in the DB' do
        post :create, category_id: cat.id, resource: { name: 'test resource' }
        resource = Resource.last
        expect(resource.name).to eq 'test resource'
        expect(resource.category_id).to eq cat.id
        expect(response).to redirect_to categories_path
      end

      it 'properly deals with validation errors' do
        post :create, category_id: cat.id, resource: { name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Resource.count).to eq 0
      end

      it 'returns a 404 error - if the category is NOT found' do
        post :create, category_id: 'TACOCAT', resource: { name: 'test resource' }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'resources#edit' do
      it 'shows the edit form - if the resource is found' do
        get :edit, id: res.id
        expect(response).to have_http_status(:success)
      end

      it 'returns a 404 error - if the resource is NOT found' do
        get :edit, id: 'TACOCAT'
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'resources#update' do
      it 'updates the resource in the DB, re-direct to #show page - if the resource is found' do
        patch :update, id: res.id, resource: { name: 'test resource updated' }
        expect(response).to redirect_to category_path(res.category_id)
        # verifies the resource we originally created for the test had it's name
        # updated - AFTER we reload the contents of the record, then we can check
        # that that the :name value was updated
        res.reload
        expect(res.name).to eq 'test resource updated'
      end

      it 'renders resources#edit form as unprocessable_entity - if the form validation fails' do
        patch :update, id: res.id, resource: { name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        res.reload
        expect(res.name).to eq 'test resource'
      end

      it 'returns a 404 error - if the resource is NOT found' do
        patch :update, id: 'TACOCAT', resource: { name: 'test resource updated' }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'resources#destroy action' do
      it 'removes the resource from the DB, redirect to #index page - if the resource is found' do
        res = FactoryGirl.create(:resource)
        delete :destroy, id: res.id
        expect(response).to redirect_to categories_path
        # tries to find the resource record in the DB with an id of the one we just deleted
        res = Resource.find_by(id: res.id)
        expect(res).to eq nil
      end

      it 'returns a 404 error - if the resource is NOT found' do
        delete :destroy, id: 'TACOCAT'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when user is not logged in' do
    describe 'resources#new' do
      it 'requires a user to be logged in to view the resources#new page' do
        get :new, category_id: cat.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'resources#create' do
      it 'requires a user to be logged in to submit the resources#new form' do
        post :create, category_id: cat.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'resources#edit' do
      it 'requires a user to be logged in to view the resources#edit page' do
        get :edit, id: res.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'resources#update' do
      it 'requires a user to be logged in to submit the resources#edit form' do
        patch :update, id: res.id, resource: { name: 'test resource updated' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'resources#destroy' do
      it 'requires a user to be logged in to destroy a resource' do
        delete :destroy, id: res.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

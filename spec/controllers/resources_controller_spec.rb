require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  let(:cat) { Category.create(name: 'test category') }
  let(:res) { Resource.create(name: 'test resource', category_id: 57) }

  describe 'resources#new' do
    it 'shows the new resource form page' do
      # triggers HTTP GET request to /categories/:category_id/resources/new
      get :new, category_id: cat.id
      expect(response).to have_http_status(:success) # verify the page loads successfully
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

    it 'returns a 404 error - if the category is NOT found' do
      post :create, category_id: 'TACOCAT', resource: { name: 'test resource' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'resources#show' do
    it 'shows the page - if the resource is found' do
      # triggers HTTP GET request to /categories/:category_id/resources/:id
      get :show, category_id: cat.id, id: res.id
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the resource is NOT found' do
      get :show, category_id: cat.id, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a 404 error - if the category is NOT found' do
      get :show, category_id: 'TACOCAT', id: res.id
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'resources#edit' do
    it 'shows the edit form - if the resource is found' do
      get :edit, category_id: cat.id, id: res.id
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the resource is NOT found' do
      get :edit, category_id: cat.id, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns a 404 error - if the category is NOT found' do
      get :edit, category_id: 'TACOCAT', id: res.id
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'resources#update' do
    it 'updates the resource in the DB, re-direct to #show page - if the resource is found' do
      patch :update, category_id: cat.id, id: res.id, resource: { name: 'test resource updated' }
      expect(response).to redirect_to category_path(res.category_id)
      # verifies the resource we originally created for the test had it's name
      # updated - AFTER we reload the contents of the record, then we can check
      # that that the :name value was updated
      res.reload
      expect(res.name).to eq 'test resource updated'
    end

    it 'returns a 404 error - if the resource is NOT found' do
      patch :update, category_id: cat.id, id: 'TACOCAT', resource: { name: 'test resource updated' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'resources#destroy action' do
    it 'removes the resource from the DB, redirect to #index page - if the resource is found' do
      delete :destroy, category_id: cat.id, id: res.id
      expect(response).to redirect_to categories_path
      # tries to find the resource record in the DB with an id of the one we just deleted
      @res = Resource.find_by(id: res.id)
      expect(@res).to eq nil
    end

    it 'returns a 404 error - if the resource is NOT found' do
      delete :destroy, category_id: cat.id, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end
end

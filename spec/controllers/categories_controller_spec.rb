require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'categories#index' do
    it 'shows the page' do
      get :index
      expect(response).to have_http_status(:success) # verify the page loads successfully
    end
  end

  describe 'categories#new' do
    it 'shows the new cagegory form page' do
      get :new
      expect(response).to have_http_status(:success) # verify the page loads successfully
    end
  end

  describe 'categories#create' do
    it 'creates a new category in the DB' do
      post :create, category: { name: 'test category' }
      cat = Category.last
      expect(cat.name).to eq 'test category'
      expect(response).to redirect_to categories_path
    end
  end

  describe 'categories#show' do
    it 'shows the page - if the category is found' do
      # pushes a new category into the DB
      post :create, category: { name: 'test category' }
      cat = Category.last
      # triggers HTTP GET request to /categories/:id, where :id is given the cat.id we just created
      get :show, id: cat.id
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the category is NOT found' do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'categories#edit' do
    it 'shows the edit form - if the category is found' do
      post :create, category: { name: 'test category' }
      cat = Category.last
      get :edit, id: cat.id
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the category is NOT found' do
      get :edit, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'categories#update' do
    it 'updates the category in the DB, re-direct to #show page - if the category is found' do
      post :create, category: { name: 'test category' }
      cat = Category.last
      patch :update, id: cat.id, category: { name: 'test category updated' }
      expect(response).to redirect_to category_path
      # verifies the category we originally created for the test had it's name
      # updated - AFTER we reload the contents of the record, then we can check
      # that that the :message value was updated
      cat.reload
      expect(cat.name).to eq 'test category updated'
    end

    it 'returns a 404 error - if the category is NOT found' do
      patch :update, id: 'TACOCAT', category: { name: 'test category updated' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'categories#destroy action' do
    it 'removes the category from the DB, redirect to #index page - if the category is found' do
      post :create, category: { name: 'test category' }
      cat = Category.last
      delete :destroy, id: cat.id
      expect(response).to redirect_to categories_path
      # tries to find the category record in the DB with an id of the one we just created & deleted
      cat = Category.find_by(id: cat.id)
      expect(cat).to eq nil
    end

    it 'returns a 404 error - if the category is NOT found' do
      delete :destroy, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end
end

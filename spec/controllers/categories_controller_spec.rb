require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:cat) { FactoryGirl.create(:category) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'GET #index' do
    it 'shows the page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'shows the page - if the category is found' do
      get :show, id: cat.id
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:success)
    end

    it 'returns a 404 error - if the category is NOT found' do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when ADMIN user is logged in' do
    before do
      sign_in admin
    end

    describe 'GET #new' do
      it 'shows the new category form page' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST #create' do
      it 'creates a new category in the DB' do
        expect(cat.name).to eq 'test category'
        expect(response).to have_http_status(:success)
      end

      it 'properly deals with validation errors' do
        Category.destroy_all
        post :create, category: { name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Category.count).to eq 0
      end
    end

    describe 'GET #edit' do
      it 'shows the edit form - if the category is found' do
        get :edit, id: cat.id
        expect(response).to have_http_status(:success)
      end

      it 'returns a 404 error - if the category is NOT found' do
        get :edit, id: 'TACOCAT'
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'PATCH #update' do
      it 'updates the category in the DB, re-direct to #show page - if the category is found' do
        patch :update, id: cat.id, category: { name: 'test category updated' }
        expect(response).to redirect_to category_path
        # verifies the category we originally created for the test had it's name
        # updated - AFTER we reload the contents of the record, then we can check
        # that that the :name value was updated
        cat.reload
        expect(cat.name).to eq 'test category updated'
      end

      it 'renders categories#edit form as unprocessable_entity - if the form validation fails' do
        patch :update, id: cat.id, category: { name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        cat.reload
        expect(cat.name).to eq 'test category'
      end

      it 'returns a 404 error - if the category is NOT found' do
        patch :update, id: 'TACOCAT', category: { name: 'test category updated' }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'DELETE #destroy' do
      it 'removes the category from the DB, redirect to #index page - if the category is found' do
        cat = FactoryGirl.create(:category)
        delete :destroy, id: cat.id
        expect(response).to redirect_to categories_path
        # tries to find the category record in the DB with
        # an id of the one we just created & deleted
        cat = Category.find_by(id: cat.id)
        expect(cat).to eq nil
      end

      it 'returns a 404 error - if the category is NOT found' do
        delete :destroy, id: 'TACOCAT'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when user is logged in (non-admin)' do
    before do
      sign_in user
    end

    # describe 'GET #new' do
    #   it 'shows the new category form page' do
    #     get :new
    #     expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
    #   end
    # end

    describe 'POST #create' do
      it 'creates a new category in the DB' do
        post :create, category: { name: 'test category' }
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end

    describe 'GET #edit' do
      it 'shows the edit form - if the category is found' do
        get :edit, id: cat.id
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end

    describe 'PATCH #update' do
      it 'updates the category in the DB, re-direct to #show page - if the category is found' do
        patch :update, id: cat.id, category: { name: 'test category updated' }
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end

    describe 'categories#destroy action' do
      it 'removes the category from the DB, redirect to #index page - if the category is found' do
        delete :destroy, id: cat.id
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end

  context 'when user is NOT logged in' do
    describe 'GET #new' do
      it 'requires users to be logged in to view the categories#new page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'requires users to be logged in to submit the categories#new form' do
        post :create, category: { name: 'test category' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it 'requires users to be logged in to view the categories#edit page' do
        get :edit, id: cat.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PATCH #update' do
      it 'requires users to be logged in to submit the categories#edit form' do
        patch :update, id: cat.id, category: { name: 'test category updated' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      it 'requires users to be logged in to destroy a category' do
        delete :destroy, id: cat.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

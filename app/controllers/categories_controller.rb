class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :show]

  def index
    @categories = Category.all
  end

  def new
    @category = authorize Category.new
  end

  def create
    @category = Category.create(category_params)
    authorize @category
    if @category.valid?
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    authorize @category
  end

  def update
    authorize @category
    @category.update_attributes(category_params)
    if @category.valid?
      redirect_to category_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @category
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    return render_not_found if @category.blank?
  end

  def render_not_found
    render text: 'Not Found :(', status: :not_found
  end
end

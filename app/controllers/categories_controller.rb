class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    Category.create(category_params)
    redirect_to categories_path
  end

  def show
  end

  def edit
  end

  def update
    @category.update_attributes(category_params)
    redirect_to category_path
  end

  def destroy
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
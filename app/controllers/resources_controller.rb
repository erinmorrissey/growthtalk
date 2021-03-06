class ResourcesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_resource, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, only: [:edit?, :update?, :destroy?]

  def new
    @category = Category.find_by(id: params[:category_id])
    @resource = Resource.new
  end

  def create
    @category = Category.find_by(id: params[:category_id])
    return render text: 'Not Found :(', status: :not_found if @category.blank?
    @resource = @category.resources.create(resource_params)
    if @resource.valid?
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find_by(id: @resource.category_id)
    @comment = Comment.new
  end

  def edit
    authorize @resource
  end

  def update
    authorize @resource
    @resource.update_attributes(resource_params)
    if @resource.valid?
      redirect_to category_path(@resource.category_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @resource
    @resource.destroy
    redirect_to categories_path
  end

  private

  def resource_params
    params.require(:resource).permit(:name, :url, :logo_image)
  end

  def find_resource
    @resource = Resource.find_by(id: params[:id])
    return render_not_found if @resource.blank?
  end

  def render_not_found
    render text: 'Not Found :(', status: :not_found
  end
end

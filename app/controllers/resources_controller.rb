class ResourcesController < ApplicationController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def new
    @category = Category.find_by(id: params[:category_id])
    @resource = Resource.new
  end

  def create
    @category = Category.find_by(id: params[:category_id])
    return render text: 'Not Found :(', status: :not_found if @category.blank?
    @category.resources.create(resource_params)
    redirect_to categories_path
  end

  def show
  end

  def edit
  end

  def update
    @resource.update_attributes(resource_params)
    redirect_to category_path(@resource.category_id)
  end

  def destroy
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

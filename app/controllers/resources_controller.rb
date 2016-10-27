class ResourcesController < ApplicationController
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
    @category = Category.find_by(id: params[:category_id])
    @resource = Resource.find_by(id: params[:id])
    return render text: 'Not Found :(', status: :not_found if @category.blank? || @resource.blank?
  end

  def edit
    @category = Category.find_by(id: params[:category_id])
    @resource = Resource.find_by(id: params[:id])
    return render text: 'Not Found :(', status: :not_found if @category.blank? || @resource.blank?
  end

  def update
    @resource = Resource.find_by(id: params[:id])
    return render text: 'Not Found :(', status: :not_found if @resource.blank?
    @resource.update_attributes(resource_params)
    redirect_to category_path(@resource.category_id)
  end

  def destroy
    @resource = Resource.find_by(id: params[:id])
    return render text: 'Not Found :(', status: :not_found if @resource.blank?
    @resource.destroy
    redirect_to categories_path
  end

  private

  def resource_params
    params.require(:resource).permit(:name, :url, :logo_image)
  end
end

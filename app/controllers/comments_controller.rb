class CommentsController < ApplicationController
  def create
    @resource = Resource.find_by(id: params[:resource_id])
    return render text: 'Not Found :(', status: :not_found if @resource.blank?
    @resource.comments.create(comment_params)
    redirect_to resource_path(@resource)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_text)
  end
end

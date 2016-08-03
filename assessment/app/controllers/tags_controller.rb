class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find_by(id: params[:id])
    if @tag.nil?
      not_found
    end
  end

  def new
    @tag = Tag.new
    @create_or_update_text = "Create"
  end

  def create
    tag = Tag.find_or_create_by(tag_params)

    redirect_to tag_path(tag)
  end

  def edit
    @tag = Tag.find_by(id: params[:id])
    if @tag.nil?
      not_found
    elsif not authorize_resource(@tag,:edit)
      redirect_to lists_path
    end
    @create_or_update_text = "Update"
  end

  def update
    tag = Tag.find(params[:id])
    return redirect_to lists_path if not authorize_resource(tag,:update)
    tag.update(tag_params)

    redirect_to tag_path(tag)
  end

  def destroy
    tag = Tag.find(params[:id])
    return redirect_to lists_path if not authorize_resource(tag,:destroy)
    tag.destroy

    redirect_to lists_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end

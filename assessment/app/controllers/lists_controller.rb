class ListsController < ApplicationController
  def index
    @lists = current_user.lists
  end

  def show
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    end
  end

  def new
    @list = List.new
    @create_or_update_text = "Create"
  end

  def create
    list = List.create(list_params) 

    redirect_to user_path(current_user)
# make nested user/lists/:id ?
  end

  def edit
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    end
    @create_or_update_text = "Update"
  end

  def update
    list = List.find(params[:id])
    list.update(list_params)

    redirect_to user_path(current_user)
# make nested user/lists/:id ? 
  end

  def destroy
    list = List.find_by(id: params[:id])
    if list.nil?
      not_found
    end
    list.destroy

    redirect_to user_path(current_user)
  end

  private

  def list_params
    params.require(:list).permit(:name,:user_id)
  end
end

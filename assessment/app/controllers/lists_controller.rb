class ListsController < ApplicationController
  def index
    @lists = current_user.lists
  end

  def show
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    elsif !authorize_resource(@list,:show)
      redirect_to user_path(current_user)
    end
    @task = Task.new
  end

  def new
    @list = List.new
    @create_or_update_text = "Create"
  end

  def create
    list = List.create(list_params)
    list.users << current_user
    list.update_permission(current_user,"creator")

    redirect_to list_path(list)
  end

  def edit
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    elsif !authorize_resource(@list,:edit)
      redirect_to user_path(current_user)
    end
    @create_or_update_text = "Update"
  end

  def update
    list = List.find(params[:id])
    list.update(list_params)

    redirect_to user_path(current_user)
  end

  def destroy
    list = List.find_by(id: params[:id])
    if list.nil?
      not_found
    elsif !authorize_resource(@list,:destroy)
    end
    list.tasks.map(&:destroy)
    list.destroy

    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end

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
    @list = List.new(name: list_params[:name])
    if not @list.save
      @create_or_update_text = "Create"
      return render :new
    end
    @list.users << current_user
    @list.update_permission(current_user,"creator")
    @list.collaborators = list_params[:collaborators]

    redirect_to list_path(@list)
  end

  def edit
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    elsif !authorize_resource(@list,:edit)
      redirect_to lists_path
    end
    @create_or_update_text = "Update"
  end

  def update
    @list = List.find(params[:id])
    return redirect_to lists_path if !authorize_resource(@list,:update)
    if not @list.update(list_params)
      @create_or_update_text = "Update"
      return render :edit 
    end
    redirect_to list_path(@list)
  end

  def destroy
    list = List.find_by(id: params[:id])
    return redirect_to lists_path if not authorize_resource(list,:destroy)
    list.tasks.map(&:destroy)
    list.destroy

    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name,:collaborators)
  end
end

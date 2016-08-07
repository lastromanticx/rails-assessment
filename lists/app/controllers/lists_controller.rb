class ListsController < ApplicationController
  def index
    @lists = current_user.lists
  end

  def show
    @list = List.find_by(id: params[:id])
    if @list.nil?
      not_found
    elsif !authorize_resource(current_user,@list,:show)
      return redirect_to lists_path
    end
    @task = Task.new
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(name: list_params[:name])
    if not @list.save
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
    elsif !authorize_resource(current_user,@list,:edit)
      return redirect_to lists_path
    end
  end

  def update
    @list = List.find(params[:id])
    return redirect_to lists_path if !authorize_resource(current_user,@list,:update)
    if not @list.update(list_params)
      return render :edit 
    end
    redirect_to list_path(@list)
  end

  def destroy
    list = List.find_by(id: params[:id])
    return redirect_to lists_path if not authorize_resource(current_user,list,:destroy)
    list.tasks.map(&:destroy)
    list.destroy

    redirect_to lists_path
  end

  def search
    if params[:search]
      @results = List.search(search_params["query"],search_params["list_id"],current_user.id)
      @query = search_params.to_h
    end
  end

  private

  def list_params
    params.require(:list).permit(:name,:collaborators)
  end

  def search_params
    params.require(:search).permit(:query,:list_id)
  end
end

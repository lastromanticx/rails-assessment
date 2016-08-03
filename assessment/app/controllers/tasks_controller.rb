class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    if not @task.save
      @list = List.find(params[:task][:list_id])
      @create_or_update_text = "Create"
      return render '/lists/show', id: params[:task][:list_id]
    end
    @task.update(status: "Incomplete")

    redirect_to list_path(task_params[:list_id]) 
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      not_found
    elsif not authorize_resource(@task,:show)
      redirect_to lists_path
    end
  end

  def edit
    if params[:list_id]
      list = List.find_by(id: params[:list_id])
      if list.nil?
        flash[:warning] = "List not found."
        redirect_to lists_path
      elsif not authorize_resource(list,:show)
        redirect_to lists_path
      else
        @task = list.tasks.find_by(id: params[:id])
        if @task.nil? 
          flash[:warning] = "Task not found."
          redirect_to list_path(list)
        end
      end
    else
      @task = task.find(params[:id])
    end
  end

  def update
    @task = Task.find(params[:id])
    return redirect_to lists_path if not authorize_resource(@task,:update)
    if not @task.update(task_params)
      @create_or_update_text = "Update"
      return render :edit
    end

    redirect_to task_path(@task)
  end

  private

  def task_params
    params.require(:task).permit(:name,:description,:due_date,:status,:list_id, tag_ids: [], tags_attributes: [:name])
  end
end

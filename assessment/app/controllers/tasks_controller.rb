class TasksController < ApplicationController
  def create
    task = Task.create(task_params)
    task.update(status: "Incomplete")

    redirect_to list_path(task_params[:list_id]) 
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      not_found
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if @task.nil?
      not_found
    elsif @task.list.user != current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)

    redirect_to task_path(task)
  end

  private

  def task_params
    params.require(:task).permit(:name,:description,:due_date,:status,:list_id)
  end
end

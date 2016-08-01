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

  private

  def task_params
    params.require(:task).permit(:name,:description,:due_date,:status,:list_id)
  end
end

class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    if params[:category_id]
      @category = current_user.categories.find(params[:category_id])
      @tasks = @category.tasks.where(user_id: current_user.id)
    else
      @tasks = current_user.tasks
    end

    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_date, :category_id, :is_completed)
  end
end

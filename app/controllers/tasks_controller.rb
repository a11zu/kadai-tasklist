class TasksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @tasks = Task.all.page(params[:page])
    render "toppages/index"
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

   def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render 'toppages/index'
    end
  end


  def edit
    set_task
  end

  def update
    set_task
    if @task.update(task_params)
      flash[:success] = 'Message は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Message は更新されませんでした'
      render :edit
    end
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end

  
  def destroy
    set_task
    @task.destroy

    flash[:success] = 'Message は正常に削除されました'
    redirect_to tasks_url
  end

  private
  
  def set_task
    @task = Task.find(params[:id])
  end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content,:status)
  end
end

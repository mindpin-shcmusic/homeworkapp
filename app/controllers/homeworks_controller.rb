class HomeworksController < ApplicationController
  def create
    @homework = current_user.homeworks.build(params[:homework])
    return redirect_to @homework if @homework.save

    error = @homework.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  def new
    @homework = Homework.new
  end

  def index
  end

  def show
    @homework = Homework.find(params[:id])
  end

end

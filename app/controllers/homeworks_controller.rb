class HomeworksController < ApplicationController
  def create
    @homework = current_user.homeworks.build(params[:homework])
    @homework.save
  end

  def new
    @homework = Homework.new
  end

  def index
  end

  def show
  end

end

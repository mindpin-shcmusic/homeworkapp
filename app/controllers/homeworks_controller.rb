class HomeworksController < ApplicationController
  before_filter :pre_load

  def pre_load
    return redirect_to '/' unless current_user.is_teacher?
  end
  
  
  def create
    @homework = current_user.homeworks.build(params[:homework])
    if @homework.save
      homework_teacher_attachement = HomeworkTeacherAttachement.find(session[:attachement_id])
      homework_teacher_attachement.homework_id = @homework.id
      homework_teacher_attachement.creator_id = current_user.id
      homework_teacher_attachement.save
      return redirect_to @homework
    end
    
    error = @homework.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  redirect_to '/homeworks/new'
  end
  
  def create_teacher_attachement
    @homework_teacher_attachement = HomeworkTeacherAttachement.create( params[:homework_teacher_attachement] )
    session[:attachement_id] = @homework_teacher_attachement.id
    render :text => @homework_teacher_attachement.id
  end
  

  def new
    @homework = Homework.new
    @homework_student_attachement = HomeworkStudentAttachement.new
    
    # 所有课程
    @courses = Course.all
    
    # 学生列表
    @students = Student.all
  end

  def index
    @homeworks = current_user.homeworks
  end

  def show
    @homework = Homework.find(params[:id])
    @unsubmitted_students = @homework.unsubmitted_students
    @submitted_students = @homework.submitted_students
  end

end

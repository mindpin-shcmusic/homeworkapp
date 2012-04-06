class StudentController < ApplicationController
  def index
    if params[:status] == 'deadline'
      @homeworks = current_user.deadline_homeworks
    elsif params[:status] == 'undeadline'
      @homeworks = current_user.undeadline_homeworks
    else
      @homeworks = current_user.assigned_homeworks
    end
    
  end

  def show
    @homework = Homework.find(params[:id])
    @student = current_user.homework_assigns.find_by_homework_id(params[:id])
    @homework_assign = HomeworkAssign.new
  end

  def create
    @homework_assign = current_user.homework_assigns.find_by_homework_id(params[:homework_assign][:homework_id])
    @homework_assign.content = params[:homework_assign][:content]
    @homework_assign.is_submit = true
    @homework_assign.submitted_at = DateTime.now
    return redirect_to :back if @homework_assign.save

    error = @homework_assign.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :show
  end
  
  # 学生上传作业附件
  def upload_homework_attachement
    # attachement_id 值由页面ajax url 参数传进来
    params[:homework_student_upload][:attachement_id] = params[:attachement_id]
    params[:homework_student_upload][:creator_id] = current_user.id
    HomeworkStudentUpload.create( params[:homework_student_upload] )
    render :nothing => true
  end
  
  def upload_homework_attachement_again
    @homework_student_upload = HomeworkStudentUpload.find(params[:attachement_id])
  end

end

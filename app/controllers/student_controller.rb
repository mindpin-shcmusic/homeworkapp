require 'zip/zip'
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
    
    # 生成老师上传的附件压缩包
    zipfile_name = "/web/2012/homework_teacher_attachements/homework_teacher#{current_user.id}_#{@homework.id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      @homework.homework_teacher_attachements.each do |file|
        unless zipfile.find_entry(file.attachement_file_name)
          zipfile.add(file.attachement_file_name, file.attachement.path)
        end
      end
    end
  end

  def create
    @homework_assign = current_user.homework_assigns.find_by_homework_id(params[:homework_assign][:homework_id])
    @homework_assign.content = params[:homework_assign][:content]
    @homework_assign.is_submit = true
    @homework_assign.has_finished = true
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
    @homework_student_upload = HomeworkStudentUpload.create( params[:homework_student_upload] )

    # 当前作业ID, 用于生成 zip 文件名
    homework_id = @homework_student_upload.homework_student_attachement.homework.id
    zipfile_name = "/web/2012/homework_student_uploads/homework_student#{current_user.id}_#{homework_id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add(@homework_student_upload.attachement_file_name, @homework_student_upload.attachement.path)
    end
    
    render :nothing => true
  end
  
  # 学生重新上传作业附件
  def upload_homework_attachement_again
    @homework_student_upload = HomeworkStudentUpload.find_current(current_user.id, params[:attachement_id])
    old_file = @homework_student_upload.attachement_file_name;
    @homework_student_upload.attachement = params[:homework_student_upload][:attachement]
    @homework_student_upload.save
    
    # 当前作业ID, 用于生成 zip 文件名
    homework_id = @homework_student_upload.homework_student_attachement.homework.id
    zipfile_name = "/web/2012/homework_student_uploads/homework_student#{current_user.id}_#{homework_id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.remove(old_file) if zipfile.find_entry(old_file)
      zipfile.add(@homework_student_upload.attachement_file_name, @homework_student_upload.attachement.path)
    end
    
    render :nothing => true
  end

end

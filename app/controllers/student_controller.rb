require 'zip/zip'
class StudentController < ApplicationController
  def index
    if params[:status] == 'deadline'
      @homeworks = current_user.deadline_student_homeworks
    elsif params[:status] == 'undeadline'
      @homeworks = current_user.undeadline_student_homeworks
    else
      @homeworks = current_user.assigned_homeworks
    end
    
  end

  def show
    @homework = Homework.find(params[:id])
    @student_homework = current_user.homework_assigns.find_by_homework_id(params[:id])
    @homework_assign = HomeworkAssign.new

  end

  def create
    homework = Homework.find(params[:homework_assign][:homework_id])
    return redirect_to :back if homework.submit_by_student(current_user,params[:homework_assign][:content])

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
    homework_id = @homework_student_upload.homework_student_upload_requirement.homework.id
    zipfile_name = "/web/2012/homework_student_uploads/homework_student#{current_user.id}_#{homework_id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add(@homework_student_upload.attachement_file_name, @homework_student_upload.attachement.path)
    end
    
    render :nothing => true
  end
  
  # 学生重新上传作业附件
  def upload_homework_attachement_again
    homework_student_upload_requirement = HomeworkStudentUploadRequirement.find(params[:attachement_id])
    @homework_student_upload = homework_student_upload_requirement.upload_of_user(current_user)
    old_file = @homework_student_upload.attachement_file_name;
    @homework_student_upload.attachement = params[:homework_student_upload][:attachement]
    @homework_student_upload.save
    
    # 当前作业ID, 用于生成 zip 文件名
    homework_id = @homework_student_upload.homework_student_upload_requirement.homework.id
    zipfile_name = "/web/2012/homework_student_uploads/homework_student#{current_user.id}_#{homework_id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.remove(old_file) if zipfile.find_entry(old_file)
      zipfile.add(@homework_student_upload.attachement_file_name, @homework_student_upload.attachement.path)
    end
    
    render :nothing => true
  end

end

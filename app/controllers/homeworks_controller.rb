class HomeworksController < ApplicationController
  before_filter :pre_load

  def pre_load
    return redirect_to '/' unless current_user.is_teacher?
  end
  
  
  def create
    @homework = current_user.homeworks.build(params[:homework])
    if @homework.save
      teacher_attachements = params[:teacher_attachements]
      unless teacher_attachements.blank?
        teacher_attachements.each do |attachement_id|
          homework_teacher_attachement = HomeworkTeacherAttachement.find(attachement_id)
          homework_teacher_attachement.homework_id = @homework.id
          homework_teacher_attachement.creator_id = current_user.id
          homework_teacher_attachement.save
        end
      end
      
      teams = params[:teams]
      unless teams.blank?
        teams.each do |team_id|
          team = Team.find(team_id)
                   
          team.team_students.each do |student|

            unless @homework.is_assigned(student.student_id)
              homework_assign = HomeworkAssign.new
              homework_assign.creator_id = student.student_id
              homework_assign.homework_id = @homework.id
              homework_assign.created_at = Time.now
              homework_assign.updated_at = Time.now
              homework_assign.save
            end
            
          end
        end
      end
      
      return redirect_to @homework
    end
    
    error = @homework.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  redirect_to '/homeworks/new'
  end
  
  def create_teacher_attachement
    @homework_teacher_attachement = HomeworkTeacherAttachement.create( params[:homework_teacher_attachement] )
    render :text => @homework_teacher_attachement.id
  end
  

  def new
    @homework = Homework.new
    @homework_student_upload_requirement = HomeworkStudentUploadRequirement.new
    
    # 所有课程
    @courses = Course.all
    
    # 班级列表
    @teams = Team.all
    
    # 学生列表
    @students = Student.all
  end

  def index
    if params[:status] == 'deadline'
      @homeworks = current_user.deadline_teacher_homeworks
    elsif params[:status] == 'undeadline'
      @homeworks = current_user.undeadline_teacher_homeworks
    else
      @homeworks = current_user.homeworks
    end
  end
  
  
  def show
    @homework = Homework.find(params[:id])
  end
  
  
  # 老师查看具体某一学生作业页面
  def student
    @homework = Homework.find(params[:homework_id])
    @student = User.find(params[:user_id])
  end
  
  def download_teacher_zip
    homework = Homework.find(params[:id])
    
    # 生成老师上传的附件压缩包
    homework.build_teacher_attachements_zip(homework.creator)
    
    render :file => "/web/2012/homework_teacher_attachements/homework_teacher#{homework.creator.id}_#{homework.id}.zip", :content_type => 'application/zip', :status => :ok
  end

end

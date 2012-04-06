class HomeworkTeacherAttachement < ActiveRecord::Base
  belongs_to :homework
  
  # 老师上传作业提交物路径
  has_attached_file :attachement, :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"
end

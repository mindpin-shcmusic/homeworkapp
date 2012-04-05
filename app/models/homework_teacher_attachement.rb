class HomeworkTeacherAttachement < ActiveRecord::Base
  has_attached_file :attachement, :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"
end

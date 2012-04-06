class HomeworkStudentUpload < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :homework_student_attachement, :class_name => 'HomeworkStudentAttachement', 
             :foreign_key => 'attachement_id'
             
  # 学生提交物路径
  has_attached_file :attachement, :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"
             
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

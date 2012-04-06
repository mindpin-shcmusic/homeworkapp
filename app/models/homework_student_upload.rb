class HomeworkStudentUpload < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :homework_student_attachement, :class_name => 'HomeworkStudentAttachement', 
             :foreign_key => 'attachement_id'

             
  # 学生提交物路径
  has_attached_file :attachement, :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension",
                    :url => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"
  
  
  def self.find_current(creator_id, attachement_id)
    HomeworkStudentUpload.where(:creator_id => creator_id, :attachement_id => attachement_id).first
  end
           
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homework_student_uploads, :class_name => 'User', :foreign_key => 'creator_id'
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # 学生是否提交作业附件
      # attachement_id 附件表主键Id
      def is_upload_homework_attachement(attachement_id)
        HomeworkStudentUpload.where(:creator_id => self.id, :attachement_id => attachement_id).exists?
      end
    end
  end
end

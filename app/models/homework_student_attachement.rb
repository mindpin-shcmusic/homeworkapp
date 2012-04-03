class HomeworkStudentAttachement < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :homework
  
  module UserMethods
    def self.included(base)
      base.has_many :homework_student_attachements
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
       
    end
  end
end

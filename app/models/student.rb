class Student < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  
  # --- 校验部分
  validates :real_name, :presence=>true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_one :student, :foreign_key => :user_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def is_student?
        return true unless self.student.nil
      end
    end
  end
end

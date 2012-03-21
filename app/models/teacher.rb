class Teacher < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  
  # --- 校验部分
  validates :real_name, :presence => true
  validates :tid, :uniqueness => { :if => Proc.new { |teacher| !teacher.tid.blank? } }
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_one :teacher, :foreign_key => :user_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def is_teacher?
        return true unless self.teacher.nil?
      end
    end
  end
end

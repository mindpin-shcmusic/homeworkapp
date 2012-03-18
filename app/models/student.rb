class Student < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  
  # --- 校验部分
  validates :real_name, :presence=>true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :students, :foreign_key => :user_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

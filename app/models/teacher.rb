class Teacher < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  has_many :homeworks, :through => :homework_assigns
  
  # --- 校验部分
  validates :real_name, :presence => true
  validates :tid, :uniqueness => { :if => Proc.new { |teacher| !teacher.tid.blank? } }
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :teachers, :foreign_key => :user_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

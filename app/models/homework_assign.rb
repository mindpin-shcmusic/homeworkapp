class HomeworkAssign < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework, :class_name => 'Homework'
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  # --- 校验方法
  #validates :creator, :presence => true
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homework_assigns, :foreign_key => :creator_id
      base.has_many :undeadline_homeworks, :through => :homeworks, :class_name => 'HomeworkAssign', :source => :homework_assigns, :conditions => ['deadline > ?', Time.new.strftime("%Y-%m-%d %H:%M:%S")]
      base.has_many :deadline_homeworks,:through=>:homework_assigns,:source=>:homework, :conditions => ['homeworks.deadline <= ?', Time.now] 
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

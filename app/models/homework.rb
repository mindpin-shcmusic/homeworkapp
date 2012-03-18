class Homework < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :homework_assigns
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  
  # 尚未提交作业
  def unsubmitted_students
    HomeworkAssign.find(
      :all,
      :conditions => {:is_submit => false, :homework_id => self.id}
    ).map{|x| x.student }
  end
  
  # 已提交作业
  def submitted_students
    HomeworkAssign.find(
      :all,
      :conditions => {:is_submit => true, :homework_id => self.id}
    ).map{|x| x.student }
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homeworks, :foreign_key => :creator_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

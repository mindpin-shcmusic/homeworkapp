class Homework < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :homework_assigns
  has_many :homework_student_attachements
  accepts_nested_attributes_for :homework_student_attachements
  
  # 未提交作业学生
  has_many :unsubmitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', false]
  
  # 已提交作业学生
  has_many :submitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', true]
  
  # 学生附件
  has_many :homework_student_attachements
  
  # 老师创建作业时上传的附件
  has_many :homework_teacher_attachements
  
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  
  def assigned_by_student(student)
    HomeworkAssign.where(:homework_id => self.id, :creator_id => student.id).first
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homeworks, :foreign_key => :creator_id
      
      # 老师未过期作业
      base.has_many :undeadline_homeworks, :class_name => 'Homework', :foreign_key => :creator_id, :conditions => ['deadline > ?', Time.new.strftime("%Y-%m-%d %H:%M:%S")]
      
      # 老师已过期作业
      base.has_many :deadline_homeworks, :class_name => 'Homework', :foreign_key => :creator_id, :conditions => ['deadline <= ?', Time.now]
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

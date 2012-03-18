class HomeworkAssign < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework, :class_name => 'Homework'
  belongs_to :student, :class_name => 'User', :foreign_key => 'creator_id'
  
  # --- 校验方法
  validates :creator_id, :presence => true
end

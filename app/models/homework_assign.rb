class HomeworkAssign < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework, :class_name => 'Homework'
  
  # --- 校验方法
  validates :creator_id, :presence => true
end

class Homework < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :homework_assigns
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  
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

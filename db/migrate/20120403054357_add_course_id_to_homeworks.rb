class AddCourseIdToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks, :course_id, :integer
  end
end

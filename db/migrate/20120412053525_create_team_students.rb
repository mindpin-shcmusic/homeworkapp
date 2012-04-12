class CreateTeamStudents < ActiveRecord::Migration
  def change
    create_table "team_students", :force => true do |t|
      t.integer  "team_id"
      t.integer  "student_id"
      t.datetime "created_at"
      t.datetime "updated_at"

      t.timestamps
    end
  end
end

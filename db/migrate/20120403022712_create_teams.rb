class CreateTeams < ActiveRecord::Migration
  def change
    create_table "teams", :force => true do |t|
      t.string   "name", :default => "", :null => false
      t.string   "cid"
      t.integer  "teacher_id"

      t.timestamps
    end
  end
end
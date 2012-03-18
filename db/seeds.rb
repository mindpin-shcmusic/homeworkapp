# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


ActiveRecord::Base.connection.execute("TRUNCATE TABLE homeworks")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE homework_assigns")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE teachers")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE students")

Teacher.create(:real_name => 'Test teacher', :user_id => 1, :tid => '666666')


Student.create(:real_name => 'Test student1', :user_id => 2, :sid => '111111')
Student.create(:real_name => 'Test student2', :user_id => 3, :sid => '222222')

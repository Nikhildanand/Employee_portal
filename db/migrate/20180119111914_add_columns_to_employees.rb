class AddColumnsToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :fb_name, :string
    add_column :employees, :fb_birthday, :date
    add_column :employees, :fb_email, :string
    add_column :employees, :fb_posts, :string
    add_column :employees, :fb_location, :string
    add_column :employees, :fb, :string
    add_column :employees, :fb_hometown, :string
  end
end

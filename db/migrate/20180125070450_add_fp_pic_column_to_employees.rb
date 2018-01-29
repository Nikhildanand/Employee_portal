class AddFpPicColumnToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :fb_picture, :string
  end
end

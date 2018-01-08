class ChangePhoneToEmployees < ActiveRecord::Migration[5.1]
  def change
    change_column :employees, :phone, :string
  end
end

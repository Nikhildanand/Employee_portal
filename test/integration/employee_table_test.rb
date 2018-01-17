require 'test_helper'

class EmployeeTableTest < ActionDispatch::IntegrationTest

  def setup
    @admin = employees(:admin)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get admin_employee_path
    assert_template 'employees/employeetable'
    assert_select 'div.pagination'
    Employee.paginate(page: 1,per_page: 10).each do |employee|
      assert_select 'a[href=?]', showemployee_path(:id => employee.id), text: employee.name if employee.admin.nil?
    end
  end

end

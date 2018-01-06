require 'test_helper'

class EmpSessionsControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @employee = employees(:employee)
    @base_title = "Employee Portal"
  end

  test "should get login" do
    get employeeportal_login_path
    assert_response :success
    assert_select "title", "Employee Login | #{@base_title}"
  end

  test "should get dashboard" do
    log_in_as @employee
    get employeeportal_dashboard_path
    assert_response :success
    assert_select "title", "Employee Home | #{@base_title}"
  end

end

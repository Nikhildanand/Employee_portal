require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  
  def setup 
    @employee = employees(:employee)
    @admin = employees(:admin)
    @base_title = "Employee Portal"
  end

  test "should get root" do
    get root_path
    assert_response :redirect
    assert_redirected_to employeeportal_login_path
  end

  test "should get edit" do
    log_in_as @employee
    get employeeportal_path
    assert_response :success
    assert_select "title", "Edit Details | #{@base_title}"
  end

  test "should get admin login" do
    get admin_login_path
    assert_response :success
    assert_select "title", "Admin Login | #{@base_title}"
  end

  test "should get admin dashboard" do
    log_in_as @admin
    get admin_dashboard_path
    assert_response :success
    assert_select "title", "Admin Dashboard | #{@base_title}"
  end

  test "should get employee table" do
    log_in_as @admin
    get admin_employee_path
    assert_response :success
    assert_select "title", "Employees | #{@base_title}"
  end

  test "should get employee details" do
    log_in_as @admin
    get admin_employeedetails_path(:id => @employee.id)
    assert_response :success
    assert_select "title", "Employee Details | #{@base_title}"
  end

  test "should get employee add page" do
    log_in_as @admin
    get admin_addemployee_path
    assert_response :success
    assert_select "title", "Add Employee | #{@base_title}"
  end

  test "should get projects page" do
    log_in_as @admin
    get admin_projects_path
    assert_response :success
    assert_select "title", "Projects | #{@base_title}"
  end

end

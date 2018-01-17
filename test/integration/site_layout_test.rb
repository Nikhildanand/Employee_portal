require 'test_helper'


class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = employees(:admin)
    @employee = employees(:employee)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '123545',
        :email => 'nikhildanand@gmail.com',
        :birthday => '03/17/1994'
    })
  end

  def adminheader
    assert_select "a[href=?]", admin_dashboard_path
    assert_select "a[href=?]", admin_employee_path 
    assert_select "a[href=?]", admin_projects_path
    assert_select "a[href=?]", root_path    
    assert_select "a[href=?]", admin_logout_path 
  end

  def employeeheader
    assert_select "a[href=?]", employeeportal_dashboard_path 
    assert_select "a[href=?]", employeeportal_path
    assert_select "a[href=?]", root_path    
    assert_select "a[href=?]", employeeportal_logout_path
  end

  test "root link" do
    get root_path
    assert_redirected_to employeeportal_login_path
    follow_redirect!
    assert_select "a[href=?]", root_path
  end

  test "admin login link" do
    get admin_login_path
    assert_template 'employees/adminlogin'
    assert_select "a[href=?]", root_path
  end
  
  test "admin dashboard link" do
    log_in_as @admin
    get admin_dashboard_path
    assert_template 'employees/admindashboard'
    adminheader
  end

  test "admin employee link" do
    log_in_as @admin
    get admin_employee_path
    assert_template 'employees/employeetable'
    adminheader
  end

  test "admin projects link" do
    log_in_as @admin
    get admin_projects_path
    assert_template 'employees/projects'
    adminheader
  end

  test "admin add employee link" do
    log_in_as @admin
    get admin_addemployee_path
    assert_template 'employees/addemployee'
    adminheader  
  end

  test "admin employee details link" do
    log_in_as @admin
    get admin_employeedetails_path(:id => @employee.id)
    assert_template 'employees/employeedetails'
    adminheader
  end

  test "employee dashboard link" do
    log_in_as @employee
    get employeeportal_dashboard_path
    assert_template 'emp_sessions/show'
    employeeheader
  end

  test "employee edit link" do
    log_in_as @employee
    get employeeportal_path
    assert_template 'employees/edit'
    employeeheader
    assert_select "a[href=?]", auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
  end

end
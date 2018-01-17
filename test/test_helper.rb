require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  fixtures :all

  # Returns true if a test employee is logged in.
  def is_logged_in?
    !session[:employee_id].nil?
  end  
  
  def is_admin?
    Employee.find_by_id(session[:employee_id]).admin
  end

  # Log in as a particular employee.
  def log_in_as(employee)
    session[:employee_id] = employee.id
  end

end

class ActionDispatch::IntegrationTest

  # Log in as a particular employee.
  def log_in_as(employee, password: 'Ha66y@Air', remember_me: '1')
    post employeeportal_login_path, params: { session: { username: employee.username,
                                          password: password,
                                          remember_me: remember_me } }
  end

end

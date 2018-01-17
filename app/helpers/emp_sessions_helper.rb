module EmpSessionsHelper

  # Logs in the given employee.
  def log_in(employee)
    session[:employee_id] = employee.id
  end

  # Remembers a employee in a persistent session.
  def remember(employee)
    employee.remember
    cookies.permanent.signed[:employee_id] = employee.id
    cookies.permanent[:remember_token] = employee.remember_token
  end

  # Returns the current logged-in employee (if any).
  def current_employee
    if (employee_id = session[:employee_id])
      @current_employee ||= Employee.find_by(id: employee_id)
    elsif (employee_id = cookies.signed[:employee_id])
      employee = Employee.find_by(id: employee_id)
      if employee && employee.authenticated?(cookies[:remember_token])
        log_in employee
        @current_employee = employee
      end
    end
  end

  # Returns true if the employee is logged in, false otherwise.
  def logged_in?
    !current_employee.nil?
  end

  # Forgets a persistent session.
  def forget(employee)
    employee.forget
    cookies.delete(:employee_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current employee.
  def log_out
    forget(current_employee)
    session.delete(:employee_id)
    @current_employee = nil
  end

  # Confirms a logged-in employee.
  def logged_in_employee
    if (!logged_in?)
      flash[:danger] = "Please log in to access this page."
      redirect_to employeeportal_login_path
    elsif current_employee.admin
      flash[:danger] = "Please log in to access this page."
      redirect_to employeeportal_login_path
    end
  end

  # Confirms a logged-in admin.
  def logged_in_admin
    unless (  logged_in? && current_employee.admin)
      flash[:danger] = "Please log in to access this page."
      redirect_to admin_login_path
    end
  end

  def logged_in_admin?
    current_employee.admin
  end
  
end
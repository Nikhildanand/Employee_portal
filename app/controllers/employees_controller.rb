class EmployeesController < ApplicationController

  before_action :logged_in_employee, only: [:edit]
  before_action :logged_in_admin, only: [:admindashboard, 
                                         :employeedetails, 
                                         :addemployee, 
                                         :employeetable, 
                                         :projects,
                                         :adminedit]

  def new
    redirect_to employeeportal_login_path
  end


  def edit
    @employee = current_employee
    if params["fb"]
      config = request.env['omniauth.auth'][:credentials]
      @graph = Koala::Facebook::API.new(config['token'])
      @user = @graph.get_object('me?fields=picture,name,email,birthday')
      if @user['email'] || @user['birthday']
        if @user['birthday'].nil?
          @user['birthday'] = @employee[:date_of_birth]
        else
          @user['birthday'] = date_converter(@user['birthday'])
        end
        if @user['email'].nil?
          @user['email'] = @employee[:personal_email]
        end
        @employee.update_attributes(personal_email: @user['email'], date_of_birth: @user['birthday'])
        redirect_to employeeportal_dashboard_path, notice: "Data fetched from facebook successfully!"
      else
        redirect_to employeeportal_path, notice: "Oops! An error occured while fetching data from facebook"
      end
      else
        render 'edit'
    end
  end

  def create
    @employee = Employee.new(employee_params_signup)
    if @employee.save
      flash[:success] = "Profile created successfully" 
      redirect_to admin_employee_path
    else
      render 'addemployee'
    end
  end
  
  def update
    @employee = Employee.find(params[:id])
    if logged_in_admin?
      if @employee.update_attributes(employee_params_admin_update) 
        flash[:success] = "Profile updated"     
        redirect_to admin_employee_path
      else 
        render 'adminedit'
      end
    else
      if @employee.update_attributes(employee_params_update) 
        flash[:success] = "Profile updated"     
        redirect_to employeeportal_dashboard_path
      else 
        render 'edit'
      end
    end
  end

  def destroy
    Employee.find(params[:id]).destroy
    redirect_to admin_employee_path
  end

  def adminlogin

  end

  def admindashboard

  end

  def employeedetails
    @employee = Employee.find(params[:id])
  end

  def addemployee
    @employee = Employee.new
  end

  def employeetable
    @employee = Employee.reorder("Name").paginate(page: params[:page], :per_page => 10)
  end

  def projects

  end

  def adminedit
    @employee = Employee.find(params[:id])
  end

  private

  def employee_params_update
    params.require(:employee).permit( :phone, :personal_email, :address, :picture)
  end

  def employee_params_signup
    params.require(:employee).permit(:name, :email, :password,
          :password_confirmation, :gender, :designation, :phone, 
          :date_of_join, :date_of_birth, :address, :active, :username)
  end

  def employee_params_admin_update
    params.require(:employee).permit(:name, :email, :password,
          :password_confirmation, :gender, :designation, :phone, 
          :date_of_join, :date_of_birth, :address, :active, :username,
          :personal_email)
  end

end
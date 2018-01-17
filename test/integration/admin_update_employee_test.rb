require 'test_helper'

class AdminUpdateEmployeeTest < ActionDispatch::IntegrationTest

  def setup
    @admin = employees(:admin)
    @employee = employees(:employee)
  end

  test "unsuccessful edit from admin" do
    log_in_as @admin
    get admin_edit_path(:id => @employee.id)
    assert_template 'employees/adminedit'
    patch admin_edit_path(:id => @employee.id), params: { employee: { phone:  "",
                                              name: "",
                                              gender: ""} }

    assert_template 'employees/adminedit'
  end

  test "successful edit" do
    log_in_as @admin
    get admin_edit_path(:id => @employee.id)
    assert_template 'employees/adminedit'
    name = "Vishak"
    password = "Password@123"
    phone  = "9496088769"
    email = "nikhildanand@hotmail.com"
    designation = "Project Head"
    date_of_join = "2018-01-02"
    date_of_birth = "1994-01-02"
    active = false
    address = "Example House, Example Street, Example City, Example District, Example State"
    patch admin_edit_path(:id => @employee.id), params: { employee: {
                                                name: name,
                                                email: email,
                                                password: password,
                                                password_confirmation: password,
                                                gender: "Male",
                                                designation: designation,
                                                phone: phone,
                                                date_of_join: date_of_join,
                                                date_of_birth: date_of_birth,
                                                address: address,
                                                active: active,
                                                username: email,
                                                personal_email: email } }
    assert_not flash.empty?
    assert_redirected_to admin_employee_path
    @employee.reload
    assert_equal name, @employee.name
    assert_equal designation, @employee.designation
    assert_equal phone,  @employee.phone
    assert_equal email, @employee.personal_email
    assert_equal Date.parse(date_of_join), @employee.date_of_join
    assert_equal Date.parse(date_of_birth), @employee.date_of_birth
    assert_equal active, @employee.active
    assert_equal address, @employee.address
  end

end

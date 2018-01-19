require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:employee)
    OmniAuth.config.mock_auth[:facebook] = {
      provider: 'facebook',
      uid: '123545',
      user_info: {email: 'nikhildanand@gmail.com', name: 'nikhil'},
      credentials: {
        token: 'EAACEdEose0cBAHzxZAziJEXHDNbzZC4Vpqajh1U4XZCYRf4ma5tP4B29GDKhkaSTpbEhaH3swwKZCfj8eYsXg3QXa80kjJsZBzBQgOZCklhJlY2X5VR1tlCMOe9c1trOGGvV8DAlLBYJZAYwCJZCsuTTUMIygxtA0wD0OYkUUvXp4jt6fMhDqer1Q89ZAOVYo7dEZD',
        secret: '91c3f3737762ef0f356ac8ebdf2c3443'
      }
    }
  end
  
  test "unsuccessful edit" do
    log_in_as @employee
    get employeeportal_path(@employee)
    assert_template 'employees/edit'
    patch employeeportal_path(:id => @employee.id), params: { employee: { phone:  "",
    personal_email: "foo@invalid"} }
    assert_template 'employees/edit'
  end
  
  test "successful edit" do
    log_in_as @employee
    get employeeportal_path(@employee)
    assert_template 'employees/edit'
    phone  = "9496088769"
    email = "nikhildanand@hotmail.com"
    patch employeeportal_path(:id => @employee.id), params: { employee: { phone:  phone,
    personal_email: email} }
    assert_not flash.empty?
    assert_redirected_to employeeportal_dashboard_path
    @employee.reload
    assert_equal phone,  @employee.phone
    assert_equal email, @employee.personal_email
  end
  
  test "successful facebook update (only birthday)" do
    stub({birthday: '03/17/1994'})
    log_in_as @employee
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to employeeportal_dashboard_path
  end

  test "successful facebook update (only email)" do
    stub({email: 'nikhildanand@gmail.com'})
    log_in_as @employee
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to employeeportal_dashboard_path
  end

  test "successful facebook update (both email and birthday)" do
    stub({email: 'nikhildanand@gmail.com', birthday: '03/17/1994'})
    log_in_as @employee
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to employeeportal_dashboard_path
  end
  
  test "unsuccessful facebook update" do
    stub({name: 'Nikhil'})
    log_in_as @employee
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to employeeportal_path
  end

  private

  def stub(body)
    stub_request(:get, "http://graph.facebook.com/v2.0/me?fields=picture,name,email,birthday").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
      to_return(status: 200, body: body.to_json, headers: {})
  end
end

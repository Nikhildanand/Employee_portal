require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  def setup
    @employee = employees(:employee)
  end

  test "should be valid" do
    assert @employee.valid?
  end

  test "name should be present" do
    @employee.name = ""
    assert_not @employee.valid?
  end

  test "name should not be blank" do
    @employee.name = "     "
    assert_not @employee.valid?
  end

  
  test "gender should accept valid genders" do
    valid_genders = %w[Male Female Other]
    valid_genders.each do |valid_gender|
      @employee.gender = valid_gender
      assert @employee.valid?, "#{valid_gender.inspect} should be valid"
    end
  end
  
  test "gender should not accept invalid genders" do
    invalid_genders = %w[ds325@ dfhswe zdfhd2 2214235 hsg964]
    invalid_genders.each do |invalid_gender|
      @employee.gender = invalid_gender
      assert_not @employee.valid?, "#{invalid_gender.inspect} should be invalid"
    end
  end

  test "designation should be present" do
    @employee.designation = ""
    assert_not @employee.valid?
  end

  test "designation should not be blank" do
    @employee.designation = "     "
    assert_not @employee.valid?
  end

  test "phone number should not be invalid" do
    invalid_phone_numbers = %w[12w345 123456789u stgfdhgvb7 123456789 12345678901]
    invalid_phone_numbers.each do |invalid_phone_number|
      @employee.phone = invalid_phone_number
      assert_not @employee.valid?, "#{invalid_phone_number.inspect} should be invalid"
    end
  end

  test "phone number should have 10 digits" do
    valid_phone_numbers = %w[1234567890 8987654321 1209348756]
    valid_phone_numbers.each do |valid_phone_number|
      @employee.phone = valid_phone_number
      assert @employee.valid?, "#{valid_phone_number.inspect} should be valid"
    end
  end

  test "phone should be unique" do
    duplicate_employee = @employee.dup
    duplicate_employee.phone = @employee.phone
    @employee.save
    assert_not duplicate_employee.valid?
  end

  test "email should be present" do
    @employee.email = ""
    assert_not @employee.valid?
  end

  test "email should not be blank" do
    @employee.email = "     "
    assert_not @employee.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @employee.email = mixed_case_email
    @employee.save
    assert_equal mixed_case_email.downcase, @employee.reload.email
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[employee@example.com employee@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @employee.email = valid_address
      assert @employee.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[employee@example,com employee_at_foo.org employee.name@example.
                        foo@bar..com    foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @employee.email = invalid_address
      assert_not @employee.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_employee = @employee.dup
    duplicate_employee.email = @employee.email.upcase
    @employee.save
    assert_not duplicate_employee.valid?
  end

  test "date of join should be present" do
    @employee.date_of_join = " "
    assert_not @employee.valid?
  end

  test "date of join should not be invalid" do
    invalid_dates_of_join = ["2009-12-31", (Date.today + 31), "2017-13-13", "2017-02-29", 10.years.ago ]
    invalid_dates_of_join.each do |invalid_date_of_join|
      @employee.date_of_join = invalid_date_of_join
      assert_not @employee.valid?, "#{invalid_date_of_join.inspect} should be valid"
    end
  end

  test "date of join should be valid" do
    valid_dates_of_join = [(Date.today + 30), "2010-01-01", Date.today, Date.yesterday, Date.tomorrow, 1.year.ago]
    valid_dates_of_join.each do |valid_date_of_join|
      @employee.date_of_join = valid_date_of_join
      assert @employee.valid?, "#{valid_date_of_join.inspect} should be valid"
    end
  end

  test "date of birth should not be invalid" do
    invalid_dates_of_birth = [17.year.ago, (Date.today + 31), 100.year.ago ]
    invalid_dates_of_birth.each do |invalid_date_of_birth|
      @employee.date_of_birth = invalid_date_of_birth
      assert_not @employee.valid?, "#{invalid_date_of_birth.inspect} should be valid"
    end
  end

  test "date of birth should be valid" do
    valid_dates_of_birth = [18.year.ago, 99.year.ago, "1994-03-17"]
    valid_dates_of_birth.each do |valid_date_of_birth|
      @employee.date_of_birth = valid_date_of_birth
      assert @employee.valid?, "#{valid_date_of_birth.inspect} should be valid"
    end
  end


  test "password should be present" do
    @employee.password = @employee.password_confirmation = " " * 8
    assert_not @employee.valid?
  end

  test "password should not be too short" do
    @employee.password = @employee.password_confirmation = "Hh@1234"
    assert_not @employee.valid?
  end

  test "password should not be too long" do
    @employee.password = @employee.password_confirmation = "Hh@1234567890123"
    assert_not @employee.valid?
  end
  
  test "password should not contain spaces" do
    invalid_passwords = [" Hh@12345678", "Hh@ 12345678"]
    invalid_passwords.each do |invalid|
      @employee.password = @employee.password_confirmation = invalid
      assert_not @employee.valid?
    end
  end

  test "password should contain uppercase letters" do
    @employee.password = @employee.password_confirmation = "abcd123$%^"
    assert_not @employee.valid?
  end

  test "password should contain lowercase letters" do
    @employee.password = @employee.password_confirmation = "ABCDEFG@123"
    assert_not @employee.valid?
  end

  test "password should contain numeric characters" do
    @employee.password = @employee.password_confirmation = "ABcd!@#$%^&*"
    assert_not @employee.valid?
  end

  test "password should contain special characters" do
    @employee.password = @employee.password_confirmation = "ABcdefgh123"
    assert_not @employee.valid?
  end

  test "password should be valid" do
    valid_passwords = ["Hh!@#4%^&*()", "@123Has123", "1/*0nJD&^%?>", "bNVCXR4$LOPI"]
    valid_passwords.each do |valid|
      @employee.password = @employee.password_confirmation = valid
      assert @employee.valid?, "#{valid.inspect} should be valid"      
    end
  end

  test "authenticated? should return false for a employee with nil digest" do
    assert_not @employee.authenticated?('')
  end

end
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new name: "Example user", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar"
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ""
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ""
    assert_not @user.valid?
  end

  test 'name should not be to long' do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test 'email validation should accept valid emails' do
    valid_addresses = ["user@example", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  test 'email validations should reject invalid addresses' do
    invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar..com", 
      "foo@bar+baz.com"]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # assert_not @user.valid?
    end
  end

  test 'email adresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email address shuled be saved as lower-case' do
    mixed_case_mail = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_mail
    @user.save
    assert_equal mixed_case_mail.downcase, @user.reload.email
  end

  test 'password should have a minimun length' do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false  with nil digest' do
    assert_not @user.authenticated?('')
  end

end
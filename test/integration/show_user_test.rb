require 'test_helper'

class ShowUserTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @inactive_user = users(:lana)
  end

  test 'active user should appear' do
    get user_path(@user)
    assert_template 'users/show'
    assert_match @user.name, response.body
  end

  test 'inactive user whould be redirected' do
    get user_path(@inactive_user)
    assert_redirected_to root_url
  end

end

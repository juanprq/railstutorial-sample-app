require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test 'layout links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path

    log_in_as @user
    follow_redirect!
    assert_select 'a', text: 'Home', href: root_path
    assert_select 'a', text: 'Help', href: help_path
    assert_select 'a', text: 'Users', href: users_path
    assert_select 'a.dropdown-toggle', text: 'Account'
    assert_select 'a', text: 'Profile', href: user_path(@user)
    assert_select 'a', text: 'Settings', href: edit_user_path(@user)
    assert_select 'a', text: 'Log out', href: logout_path
  end

  test 'signup page' do
    get signup_path
    assert_template 'users/new'
    assert_select 'title', 'Sign up | Ruby on Rails Tutorial Sample App'
  end

end

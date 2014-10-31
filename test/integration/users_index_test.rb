require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
    @inactive_user = users(:lana)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@user)
    get users_path
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a', user.name if user.activated?
    end
    assert_select 'a', text: 'delete'
    user = first_page_of_users.first
    assert_difference 'User.count', -1 do
      delete user_path(user)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'inactive users should not show in index' do
    log_in_as(@user)
    get users_path
    assert_not response.body.include?(@inactive_user.name)
  end

end

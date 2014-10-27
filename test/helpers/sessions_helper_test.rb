require "test_helper"

class SessionsHelperTest < ActionView::TestCase

  # Prueba el helper de sesión
  test 'current_user' do
    user = users(:michael)
    remember(user)
    assert_equal user, current_user
  end
  
end
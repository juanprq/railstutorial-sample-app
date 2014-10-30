require 'test_helper'

class AccountActivationsControllerTest < ActionController::TestCase

  test "should get edit" do
    get :edit
    assert_response :redirect
  end

end

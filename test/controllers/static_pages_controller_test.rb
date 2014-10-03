require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home, 'Ruby on Rails Tutorial Sample App'
    assert_response :success
    assert_select 'title'
  end

  test "should get help" do
    static_page_test :help
  end

  test "should get about" do
    static_page_test :about
  end

  test "should get contact" do
    static_page_test :contact
  end

  def static_page_test(page)
    get page
    assert_response :success
    assert_select 'title', "#{page.to_s.capitalize} | Ruby on Rails Tutorial Sample App"
  end

end

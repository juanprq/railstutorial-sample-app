require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    static_page_test :home
  end

  test "should get help" do
    static_page_test :help
  end

  test "should get about" do
    static_page_test :about
  end

  def static_page_test(page)
    get page
    assert_response :success
    assert_select 'title', "#{page.to_s.capitalize} | Ruby on Rails Tutorial Sample App"
  end

end

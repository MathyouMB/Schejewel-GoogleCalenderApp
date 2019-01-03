require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get main_main_url
    assert_response :success
  end

end

require 'test_helper'

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get games_show_url
    assert_response :success
  end

  test "should get new" do
    get games_new_url
    assert_response :success
  end

  test "should get create" do
    get games_create_url
    assert_response :success
  end

end

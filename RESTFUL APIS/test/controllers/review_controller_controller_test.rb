require 'test_helper'

class ReviewControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get review_controller_index_url
    assert_response :success
  end

  test "should get create" do
    get review_controller_create_url
    assert_response :success
  end

  test "should get show" do
    get review_controller_show_url
    assert_response :success
  end

  test "should get destroy" do
    get review_controller_destroy_url
    assert_response :success
  end

end

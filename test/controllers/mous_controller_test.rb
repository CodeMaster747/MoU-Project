require "test_helper"

class MousControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mou = mous(:one)
  end

  test "should get index" do
    get mous_url
    assert_response :success
  end

  test "should get show" do
    get mou_url(@mou)
    assert_response :success
  end

  test "should get new" do
    get new_mou_url
    assert_response :success
  end

  test "should get edit" do
    get edit_mou_url(@mou)
    assert_response :success
  end
end

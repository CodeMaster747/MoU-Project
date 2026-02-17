require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_import_url
    assert_response :success
  end

  test "should get create" do
    post imports_url
    assert_response :redirect
  end
end

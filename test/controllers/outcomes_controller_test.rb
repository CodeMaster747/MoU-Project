require "test_helper"

class OutcomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mou = mous(:one)
    @outcome = outcomes(:one)
  end

  test "should get show" do
    get mou_outcome_url(@mou, @outcome)
    assert_response :success
  end

  test "should get new" do
    get new_mou_outcome_url(@mou)
    assert_response :success
  end

  test "should get edit" do
    get edit_mou_outcome_url(@mou, @outcome)
    assert_response :success
  end
end

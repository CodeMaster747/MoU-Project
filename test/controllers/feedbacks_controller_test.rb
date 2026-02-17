require "test_helper"

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mou = mous(:one)
    @outcome = outcomes(:one)
    @feedback = feedbacks(:one)
  end

  test "should get new" do
    get new_mou_outcome_feedback_url(@mou, @outcome)
    assert_response :success
  end

  test "should get edit" do
    get edit_mou_outcome_feedback_url(@mou, @outcome, @feedback)
    assert_response :success
  end
end

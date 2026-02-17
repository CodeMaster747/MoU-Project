class DashboardController < ApplicationController
  def index
    @total_mous = Mou.count
    @active_mous = Mou.active_status.count
    @pending_mous = Mou.pending_status.count
    @expired_mous = Mou.expired_status.count

    @total_outcomes = Outcome.count
    @completed_outcomes = Outcome.completed.count

    @average_feedback_rating = Feedback.average(:rating)&.to_f
  end
end

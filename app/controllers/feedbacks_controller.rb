class FeedbacksController < ApplicationController
  before_action :set_mou
  before_action :set_outcome
  before_action :set_feedback, only: %i[edit update destroy]

  def new
    @feedback = @outcome.feedbacks.new(review_date: Date.current)
  end

  def create
    @feedback = @outcome.feedbacks.new(feedback_params)
    if @feedback.save
      redirect_to mou_outcome_path(@mou, @outcome), notice: "Feedback added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @feedback.update(feedback_params)
      redirect_to mou_outcome_path(@mou, @outcome), notice: "Feedback updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback.destroy
    redirect_to mou_outcome_path(@mou, @outcome), notice: "Feedback deleted successfully."
  end

  private

  def set_mou
    @mou = Mou.find(params[:mou_id])
  end

  def set_outcome
    @outcome = @mou.outcomes.find(params[:outcome_id])
  end

  def set_feedback
    @feedback = @outcome.feedbacks.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comments, :reviewed_by, :review_date, :achievement_status)
  end
end

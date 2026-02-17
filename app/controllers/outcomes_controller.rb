class OutcomesController < ApplicationController
  before_action :set_mou
  before_action :set_outcome, only: %i[show edit update destroy]

  def index
    redirect_to mou_path(@mou)
  end

  def show
    @feedbacks = @outcome.feedbacks.order(review_date: :desc, created_at: :desc)
  end

  def new
    @outcome = @mou.outcomes.new
  end

  def create
    @outcome = @mou.outcomes.new(outcome_params)
    if @outcome.save
      redirect_to mou_path(@mou), notice: "Outcome created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @outcome.update(outcome_params)
      redirect_to mou_outcome_path(@mou, @outcome), notice: "Outcome updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @outcome.destroy
    redirect_to mou_path(@mou), notice: "Outcome deleted successfully."
  end

  private

  def set_mou
    @mou = Mou.find(params[:mou_id])
  end

  def set_outcome
    @outcome = @mou.outcomes.find(params[:id])
  end

  def outcome_params
    params.require(:outcome).permit(
      :title,
      :description,
      :target_date,
      :responsible_person,
      :status,
      :completion_date
    )
  end
end

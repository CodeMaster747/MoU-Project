class MousController < ApplicationController
  before_action :set_mou, only: %i[show edit update destroy]

  def index
    @q = params[:q].to_s.strip
    @status = params[:status].to_s.strip

    mous = Mou.order(end_date: :desc)
    mous = mous.with_status(@status) if @status.present?

    if @q.present?
      mous = mous.where(
        "title LIKE :q OR organization_one LIKE :q OR organization_two LIKE :q",
        q: "%#{@q}%"
      )
    end

    @mous = mous.page(params[:page]).per(10)
  end

  def show
    @outcomes = @mou.outcomes.order(target_date: :asc)
  end

  def new
    @mou = Mou.new
  end

  def create
    @mou = Mou.new(mou_params)
    if @mou.save
      redirect_to @mou, notice: "MoU created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mou.update(mou_params)
      redirect_to @mou, notice: "MoU updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mou.destroy
    redirect_to mous_path, notice: "MoU deleted successfully."
  end

  private

  def set_mou
    @mou = Mou.find(params[:id])
  end

  def mou_params
    params.require(:mou).permit(
      :title,
      :organization_one,
      :organization_two,
      :department,
      :start_date,
      :end_date,
      :objective,
      :terms,
      :contact_details
    )
  end
end

class AnalyticsController < ApplicationController
  def index
    @mous_per_year = Mou.group_by_year(:start_date, format: "%Y").count

    outcomes_by_mou_id =
      Mou.left_joins(:outcomes)
         .group("mous.id")
         .order(Arel.sql("COUNT(outcomes.id) DESC"))
         .limit(10)
         .count("outcomes.id")

    titles_by_id = Mou.where(id: outcomes_by_mou_id.keys).pluck(:id, :title).to_h
    @outcomes_per_mou = outcomes_by_mou_id.each_with_object({}) do |(mou_id, count), h|
      h[titles_by_id[mou_id]] = count
    end

    @avg_feedback_over_time = Feedback.group_by_month(:review_date, format: "%b %Y").average(:rating)
    @average_feedback_rating = Feedback.average(:rating)&.to_f
  end
end

class Feedback < ApplicationRecord
  belongs_to :outcome

  enum :achievement_status, { achieved: 0, partially_achieved: 1, not_achieved: 2 }

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :reviewed_by, :review_date, :achievement_status, presence: true
end

class Outcome < ApplicationRecord
  belongs_to :mou

  has_many :feedbacks, dependent: :destroy

  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :title, :target_date, :responsible_person, :status, presence: true

  before_save :sync_completion_date

  private

  def sync_completion_date
    return unless will_save_change_to_status?

    if completed? && completion_date.blank?
      self.completion_date = Date.current
    end
  end
end

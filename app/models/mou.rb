class Mou < ApplicationRecord
  has_many :outcomes, dependent: :destroy

  validates :title, :organization_one, :organization_two, :department, :start_date, :end_date, :objective, :terms, :contact_details, presence: true
  validate :end_date_after_start_date

  scope :pending_status, -> { where("start_date > ?", Date.current) }
  scope :expired_status, -> { where("end_date < ?", Date.current) }
  scope :active_status, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }

  def self.with_status(status)
    case status.to_s
    when "pending" then pending_status
    when "active" then active_status
    when "expired" then expired_status
    else all
    end
  end

  def status
    today = Date.current

    return "pending" if start_date.present? && start_date > today
    return "expired" if end_date.present? && end_date < today

    "active"
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end
end

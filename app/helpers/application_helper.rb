module ApplicationHelper
  def mou_status_badge(mou)
    status = mou.status
    klass =
      case status
      when "active" then "bg-success"
      when "pending" then "bg-warning text-dark"
      when "expired" then "bg-secondary"
      else "bg-light text-dark"
      end

    content_tag(:span, status.titleize, class: "badge #{klass}")
  end

  def outcome_status_badge(outcome)
    klass =
      case outcome.status
      when "completed" then "bg-success"
      when "in_progress" then "bg-primary"
      when "pending" then "bg-warning text-dark"
      else "bg-light text-dark"
      end

    content_tag(:span, outcome.status.titleize, class: "badge #{klass}")
  end

  def achievement_status_badge(feedback)
    klass =
      case feedback.achievement_status
      when "achieved" then "bg-success"
      when "partially_achieved" then "bg-warning text-dark"
      when "not_achieved" then "bg-danger"
      else "bg-light text-dark"
      end

    label = feedback.achievement_status.to_s.tr("_", " ").titleize
    content_tag(:span, label, class: "badge #{klass}")
  end
end

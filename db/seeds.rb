Mou.find_or_create_by!(title: "Industry-Academia Collaboration", organization_two: "ABC Tech Pvt Ltd", start_date: 1.month.ago.to_date) do |m|
  m.organization_one = "SSN College of Engineering"
  m.department = "Computer Science"
  m.end_date = 6.months.from_now.to_date
  m.objective = "Collaborate on internships, guest lectures, and joint projects."
  m.terms = "Both parties will coordinate quarterly review meetings."
  m.contact_details = "Coordinator: Dr. X, Email: coordinator@example.com"
end

Mou.find_or_create_by!(title: "Research MoU on Sustainable Energy", organization_two: "Green Energy Labs", start_date: 1.month.from_now.to_date) do |m|
  m.organization_one = "SSN College of Engineering"
  m.department = "EEE"
  m.end_date = 1.year.from_now.to_date
  m.objective = "Joint research and workshops on renewable energy solutions."
  m.terms = "Annual review and shared publication targets."
  m.contact_details = "Coordinator: Prof. Y, Email: energy@example.com"
end

Mou.find_or_create_by!(title: "Expired Training Partnership", organization_two: "SkillUp Foundation", start_date: 2.years.ago.to_date) do |m|
  m.organization_one = "SSN College of Engineering"
  m.department = "Training & Placement"
  m.end_date = 1.year.ago.to_date
  m.objective = "Conduct training programs for final-year students."
  m.terms = "Monthly training sessions and outcome reporting."
  m.contact_details = "Coordinator: Mr. Z, Email: tnp@example.com"
end

active_mou = Mou.find_by!(title: "Industry-Academia Collaboration")
pending_mou = Mou.find_by!(title: "Research MoU on Sustainable Energy")

Outcome.find_or_create_by!(mou: active_mou, title: "Internship Program Launch") do |o|
  o.description = "Launch internships for 20 students."
  o.target_date = 2.months.from_now.to_date
  o.responsible_person = "Placement Officer"
  o.status = :in_progress
end

completed_outcome =
  Outcome.find_or_create_by!(mou: active_mou, title: "Guest Lecture Series") do |o|
    o.description = "Invite industry experts for 3 sessions."
    o.target_date = 1.month.ago.to_date
    o.responsible_person = "Department Coordinator"
    o.status = :completed
    o.completion_date = 2.weeks.ago.to_date
  end

Outcome.find_or_create_by!(mou: pending_mou, title: "Workshop Planning") do |o|
  o.description = "Plan workshop schedule and speakers."
  o.target_date = 2.months.from_now.to_date
  o.responsible_person = "Research Coordinator"
  o.status = :pending
end

Feedback.find_or_create_by!(outcome: completed_outcome, reviewed_by: "Head of Department", review_date: Date.current) do |f|
  f.rating = 4
  f.achievement_status = :partially_achieved
  f.comments = "Good participation. Improve session follow-up materials."
end

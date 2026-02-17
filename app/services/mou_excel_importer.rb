class MouExcelImporter
  Result = Struct.new(:created, :updated, :skipped, :errors, keyword_init: true)

  DEFAULT_ORG_ONE = "SSN College of Engineering"
  DEFAULT_TERMS = "To be updated."
  DEFAULT_CONTACT = "To be updated."

  def self.import(file_path)
    new(file_path).import
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def import
    created = 0
    updated = 0
    skipped = 0
    errors = []

    sheet = Roo::Spreadsheet.open(@file_path).sheet(0)
    header_row_index = find_header_row(sheet)
    if header_row_index.nil?
      return Result.new(created: created, updated: updated, skipped: sheet.last_row.to_i, errors: [ "Could not detect a header row in the Excel sheet." ])
    end

    department_hint = detect_department(sheet)
    header_row = sheet.row(header_row_index).map { |h| normalize_header(h) }

    (header_row_index + 1).upto(sheet.last_row) do |i|
      raw_row = sheet.row(i)
      row = header_row.zip(raw_row).to_h

      attrs, imported_outcome_text = build_attributes(row, department_hint:)
      if attrs.nil?
        skipped += 1
        next
      end

      mou = Mou.find_or_initialize_by(
        title: attrs[:title],
        organization_two: attrs[:organization_two],
        start_date: attrs[:start_date]
      )
      mou.assign_attributes(attrs)

      if mou.new_record?
        if mou.save
          created += 1
          upsert_imported_outcome(mou, attrs[:objective], imported_outcome_text)
        end
      else
        if mou.save
          updated += 1
          upsert_imported_outcome(mou, attrs[:objective], imported_outcome_text)
        end
      end
    rescue StandardError => e
      skipped += 1
      errors << "Row #{i}: #{e.class} - #{e.message}"
    end

    Result.new(created: created, updated: updated, skipped: skipped, errors: errors)
  end

  private

  def build_attributes(row, department_hint:)
    company = value_for(row, "name_of_the_company", "name_of_company", "company", "organization", "partner")

    title =
      value_for(row, "title", "mou_title", "name_of_mou", "mou_name", "memorandum_of_understanding", "mou") ||
      (company.present? ? "MoU - #{company}" : nil)

    org_one = value_for(row, "organization_one", "org_1", "party_one") || DEFAULT_ORG_ONE
    org_two =
      value_for(row, "organization_two", "org_2", "party_two", "collaborating_organization", "institution") ||
      company

    department = value_for(row, "department", "dept", "school", "programme", "program", "division") || department_hint || "General"

    start_date = parse_date(value_for(row, "start_date", "start", "from_date", "date_of_signing", "date_signed", "signing_date", "date"))
    end_date = parse_date(value_for(row, "end_date", "end", "to_date", "valid_till", "valid_until", "expiry_date", "expiration_date"))

    if start_date.nil? && end_date.nil?
      return nil if title.blank? && org_two.blank?

      start_date = Date.current
      end_date = Date.current + 1.year
    elsif start_date.nil?
      start_date = end_date - 1.year
    elsif end_date.nil?
      end_date = start_date + 1.year
    end

    objective =
      value_for(row, "areas_of_collaboration", "area_of_collaboration", "objective", "purpose", "scope", "area", "description") ||
      "Imported from Excel dataset."
    terms = value_for(row, "terms", "tenure", "duration", "agreement_terms") || DEFAULT_TERMS
    contact_details = value_for(row, "contact_details", "contact", "contact_person", "contact_information", "coordinator") || DEFAULT_CONTACT

    imported_outcome_text = value_for(row, "outcomes", "outcome")

    return nil if title.blank? || org_two.blank?

    [
      {
        title: title.to_s.strip,
        organization_one: org_one.to_s.strip,
        organization_two: org_two.to_s.strip,
        department: department.to_s.strip,
        start_date: start_date,
        end_date: end_date,
        objective: objective.to_s.strip,
        terms: terms.to_s.strip,
        contact_details: contact_details.to_s.strip
      },
      imported_outcome_text
    ]
  end

  def upsert_imported_outcome(mou, objective, imported_outcome_text)
    return if imported_outcome_text.blank?
    return if imported_outcome_text.to_s.strip.casecmp("nil").zero?

    description_parts = []
    description_parts << "Areas of Collaboration: #{objective}" if objective.present?
    description_parts << "Outcomes: #{imported_outcome_text}"

    outcome = mou.outcomes.find_or_initialize_by(title: "Imported Outcome")
    outcome.description = description_parts.join("\n")
    outcome.target_date ||= mou.end_date
    outcome.responsible_person ||= "To be assigned"
    outcome.status ||= "pending"
    outcome.save
  end

  def value_for(row, *keys)
    keys.each do |k|
      v = row[k]
      return v if v.present?
    end
    nil
  end

  def parse_date(value)
    return nil if value.nil?
    return value.to_date if value.respond_to?(:to_date)

    if value.is_a?(Numeric)
      Date.new(1899, 12, 30) + value.to_i
    else
      Date.parse(value.to_s)
    end
  rescue Date::Error, ArgumentError
    nil
  end

  def normalize_header(value)
    value.to_s.strip.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/\A_+|_+\z/, "")
  end

  def find_header_row(sheet)
    1.upto([ sheet.last_row.to_i, 30 ].min) do |i|
      normalized = sheet.row(i).map { |v| normalize_header(v) }
      return i if normalized.include?("name_of_the_company") || normalized.include?("areas_of_collaboration")
    end
    nil
  end

  def detect_department(sheet)
    1.upto([ sheet.last_row.to_i, 10 ].min) do |i|
      first_cell = sheet.row(i).first.to_s.strip
      next if first_cell.blank?

      if first_cell.downcase.start_with?("department")
        return first_cell.gsub(/\Adepartment\s+of\s+/i, "").strip
      end
    end
    nil
  end
end

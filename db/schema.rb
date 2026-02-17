# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_17_152437) do
  create_table "feedbacks", force: :cascade do |t|
    t.integer "achievement_status", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.integer "outcome_id", null: false
    t.integer "rating", null: false
    t.date "review_date", null: false
    t.string "reviewed_by", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_status"], name: "index_feedbacks_on_achievement_status"
    t.index ["outcome_id"], name: "index_feedbacks_on_outcome_id"
    t.index ["rating"], name: "index_feedbacks_on_rating"
  end

  create_table "mous", force: :cascade do |t|
    t.text "contact_details", null: false
    t.datetime "created_at", null: false
    t.string "department", null: false
    t.date "end_date", null: false
    t.text "objective", null: false
    t.string "organization_one", null: false
    t.string "organization_two", null: false
    t.date "start_date", null: false
    t.text "terms", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_mous_on_end_date"
    t.index ["organization_one"], name: "index_mous_on_organization_one"
    t.index ["organization_two"], name: "index_mous_on_organization_two"
    t.index ["start_date"], name: "index_mous_on_start_date"
    t.index ["title"], name: "index_mous_on_title"
  end

  create_table "outcomes", force: :cascade do |t|
    t.date "completion_date"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "mou_id", null: false
    t.string "responsible_person", null: false
    t.integer "status", default: 0, null: false
    t.date "target_date", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["mou_id"], name: "index_outcomes_on_mou_id"
    t.index ["status"], name: "index_outcomes_on_status"
    t.index ["target_date"], name: "index_outcomes_on_target_date"
  end

  add_foreign_key "feedbacks", "outcomes"
  add_foreign_key "outcomes", "mous"
end

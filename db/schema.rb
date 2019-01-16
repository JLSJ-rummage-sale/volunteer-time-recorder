# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190116191913) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.text "description"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "import_errors", force: :cascade do |t|
    t.integer "row_number"
    t.string "error_message"
    t.string "row_data"
    t.integer "spreadsheet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spreadsheet_id"], name: "index_import_errors_on_spreadsheet_id"
  end

  create_table "member_types", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "planned_shifts", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "name"
    t.text "notes"
    t.integer "event_id"
    t.integer "volunteer_id"
    t.integer "time_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_in_time"
    t.datetime "sign_out_time"
    t.integer "category_id"
    t.index ["category_id"], name: "index_planned_shifts_on_category_id"
    t.index ["event_id"], name: "index_planned_shifts_on_event_id"
    t.index ["time_record_id"], name: "index_planned_shifts_on_time_record_id"
    t.index ["volunteer_id"], name: "index_planned_shifts_on_volunteer_id"
  end

  create_table "planned_shifts_uploadeds", force: :cascade do |t|
    t.integer "spreadsheet_id"
    t.integer "planned_shift_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planned_shift_id"], name: "index_planned_shifts_uploadeds_on_planned_shift_id"
    t.index ["spreadsheet_id"], name: "index_planned_shifts_uploadeds_on_spreadsheet_id"
  end

  create_table "quotas", force: :cascade do |t|
    t.string "name"
    t.integer "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "member_type_id"
    t.index ["category_id"], name: "index_quotas_on_category_id"
    t.index ["member_type_id"], name: "index_quotas_on_member_type_id"
  end

  create_table "spreadsheets", force: :cascade do |t|
    t.string "file_name"
    t.integer "num_rows"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.index ["event_id"], name: "index_spreadsheets_on_event_id"
  end

  create_table "time_records", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "name"
    t.text "notes"
    t.integer "event_id"
    t.integer "volunteer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.index ["category_id"], name: "index_time_records_on_category_id"
    t.index ["event_id"], name: "index_time_records_on_event_id"
    t.index ["volunteer_id"], name: "index_time_records_on_volunteer_id"
  end

  create_table "volunteers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.integer "member_type_id"
    t.index ["member_type_id"], name: "index_volunteers_on_member_type_id"
  end

  create_table "volunteers_uploadeds", force: :cascade do |t|
    t.integer "spreadsheet_id"
    t.integer "volunteer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spreadsheet_id"], name: "index_volunteers_uploadeds_on_spreadsheet_id"
    t.index ["volunteer_id"], name: "index_volunteers_uploadeds_on_volunteer_id"
  end

end

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

ActiveRecord::Schema.define(version: 20221114093446) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overtime_finished_at"
    t.boolean "tomorrow", default: false
    t.string "overtime_work"
    t.string "indicater_check"
    t.string "indicater_check_anser"
    t.string "indicater_reply"
    t.boolean "change", default: false
    t.boolean "verification", default: false
    t.string "indicater_check_edit"
    t.integer "indicater_reply_edit"
    t.boolean "tomorrow_edit", default: false
    t.datetime "started_edit_at"
    t.datetime "started_before_at"
    t.datetime "finished_before_at"
    t.datetime "finished_edit_at"
    t.boolean "change_edit", default: false
    t.string "indicater_check_edit_anser"
    t.date "month_approval"
    t.string "indicater_check_month"
    t.integer "indicater_reply_month"
    t.boolean "change_month", default: false
    t.string "indicater_check_month_anser"
    t.string "one_month_request_superior"
    t.string "one_month_request_status"
    t.string "one_month_approval_status"
    t.boolean "one_month_approval_check", default: false
    t.string "business_process_content"
    t.datetime "edit_started_at"
    t.datetime "edit_finished_at"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2022-10-20 23:00:00"
    t.datetime "work_time", default: "2022-10-20 22:30:00"
    t.datetime "designated_work_end_time", default: "2022-10-21 09:00:00"
    t.datetime "basic_work_time"
    t.string "uid"
    t.string "employee_number"
    t.time "designated_work_start_time", default: "2000-01-01 09:00:00"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end

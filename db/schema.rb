# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121023195808) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "max_off"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "departments", ["max_off"], :name => "index_departments_on_max_off"
  add_index "departments", ["name"], :name => "index_departments_on_name", :unique => true

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "event_date"
    t.datetime "date_requested"
    t.integer  "user_id"
    t.integer  "approved_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request_id"
  end

  add_index "events", ["approved_by"], :name => "index_events_on_approved_by"
  add_index "events", ["date_requested"], :name => "index_events_on_date_requested"
  add_index "events", ["event_date"], :name => "index_events_on_event_date"
  add_index "events", ["name"], :name => "index_events_on_name"
  add_index "events", ["request_id"], :name => "index_events_on_request_id"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "requests", :force => true do |t|
    t.integer  "user_id"
    t.datetime "request_start"
    t.datetime "request_end"
    t.integer  "total_days"
    t.integer  "total_hours"
    t.string   "purpose"
    t.text     "comments"
    t.boolean  "scheduled"
    t.boolean  "called_in"
    t.boolean  "absence_paid"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "approved",      :default => false
    t.boolean  "denied",        :default => false
    t.text     "remarks"
  end

  add_index "requests", ["absence_paid"], :name => "index_requests_on_absence_paid"
  add_index "requests", ["approved"], :name => "index_requests_on_approved"
  add_index "requests", ["called_in"], :name => "index_requests_on_called_in"
  add_index "requests", ["comments"], :name => "index_requests_on_comments"
  add_index "requests", ["denied"], :name => "index_requests_on_denied"
  add_index "requests", ["purpose"], :name => "index_requests_on_purpose"
  add_index "requests", ["remarks"], :name => "index_requests_on_remarks"
  add_index "requests", ["request_end"], :name => "index_requests_on_request_end"
  add_index "requests", ["request_start"], :name => "index_requests_on_request_start"
  add_index "requests", ["scheduled"], :name => "index_requests_on_scheduled"
  add_index "requests", ["total_days"], :name => "index_requests_on_total_days"
  add_index "requests", ["total_hours"], :name => "index_requests_on_total_hours"
  add_index "requests", ["user_id"], :name => "index_requests_on_user_id"

  create_table "secrets", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "secrets", ["code"], :name => "index_secrets_on_code"
  add_index "secrets", ["name"], :name => "index_secrets_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "slug"
    t.datetime "last_in"
    t.integer  "in_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "department_id"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["department_id"], :name => "index_users_on_department_id"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["image"], :name => "index_users_on_image"
  add_index "users", ["in_count"], :name => "index_users_on_in_count"
  add_index "users", ["last_in"], :name => "index_users_on_last_in"
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug"

end

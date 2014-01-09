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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140102133523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: true do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "slug"
    t.string   "name"
    t.string   "location_type"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segments", force: true do |t|
    t.integer  "user_id"
    t.float    "distance",        default: 0.0
    t.integer  "steps",           default: 0
    t.integer  "duration",        default: 0
    t.float    "lat"
    t.float    "lng"
    t.boolean  "processed"
    t.integer  "neighborhood_id"
    t.integer  "city_id"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "segments", ["city_id"], name: "index_segments_on_city_id", using: :btree
  add_index "segments", ["country_id"], name: "index_segments_on_country_id", using: :btree
  add_index "segments", ["neighborhood_id"], name: "index_segments_on_neighborhood_id", using: :btree
  add_index "segments", ["state_id"], name: "index_segments_on_state_id", using: :btree
  add_index "segments", ["user_id"], name: "index_segments_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "token",                               null: false
    t.string   "refresh_token",                       null: false
    t.integer  "expires_at",                          null: false
    t.date     "first_record_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

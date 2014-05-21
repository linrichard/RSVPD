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

ActiveRecord::Schema.define(version: 20140517192534) do

  create_table "event_invites", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "phone"
    t.integer  "rsvp_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "fb_event_id"
    t.datetime "rsvp_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "location_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "privacy"
    t.float    "price"
    t.string   "phone"
    t.string   "website"
    t.integer  "creator_id"
  end

  create_table "group_users", force: true do |t|
    t.integer  "group_id"
    t.integer  "fb_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  create_table "groups", force: true do |t|
    t.integer  "creator_id"
    t.integer  "privacy"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "actor_id"
    t.integer  "receiver_id"
    t.string   "action"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "fb_user_id"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
  end

  create_table "waitlists", force: true do |t|
    t.string   "email"
    t.string   "code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

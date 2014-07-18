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

ActiveRecord::Schema.define(version: 20140718175008) do

  create_table "leagues", force: true do |t|
    t.string   "desc"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
  end

  create_table "matches", force: true do |t|
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.string   "score"
    t.integer  "court"
    t.integer  "week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game"
  end

  create_table "standings", force: true do |t|
    t.integer  "team_id"
    t.integer  "rank"
    t.integer  "tier"
    t.integer  "week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matches_played"
    t.decimal  "matches_won"
    t.integer  "sets_played"
    t.integer  "sets_won"
    t.integer  "points_diff"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "captain"
    t.string   "email"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tier_settings", force: true do |t|
    t.integer  "week_id"
    t.integer  "tier"
    t.integer  "total_teams"
    t.integer  "teams_down"
    t.string   "day"
    t.text     "schedule_pattern"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cycle"
    t.string   "set_points"
    t.string   "match_times"
    t.string   "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "vip"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "weeks", force: true do |t|
    t.integer  "league_id"
    t.integer  "week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

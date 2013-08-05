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

ActiveRecord::Schema.define(version: 20130804235915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "deploys", force: true do |t|
    t.integer  "user_id"
    t.hstore   "create_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner"
    t.string   "name"
    t.datetime "created_on_heroku_at"
    t.datetime "cloned_at"
    t.datetime "pushed_to_heroku_at"
    t.datetime "transfered_at"
    t.datetime "deploy_started_at"
    t.string   "transfer_id"
    t.string   "state"
  end

  add_index "deploys", ["user_id"], name: "index_deploys_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "heroku_id"
  end

end

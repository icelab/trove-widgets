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

ActiveRecord::Schema.define(version: 20140625205006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer  "uid"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: true do |t|
    t.datetime "date"
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.string   "url"
    t.string   "status",     default: "draft"
    t.integer  "person_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "events", ["person_id"], name: "index_events_on_person_id", using: :btree

  create_table "experiences", force: true do |t|
    t.integer  "person_id"
    t.string   "company_ru"
    t.string   "title_ru"
    t.text     "description_ru"
    t.date     "start"
    t.date     "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "still"
    t.string   "company_en"
    t.string   "title_en"
    t.text     "description_en"
  end

  create_table "follows", force: true do |t|
    t.integer  "profile_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["follower_id"], name: "index_follows_on_follower_id", using: :btree
  add_index "follows", ["profile_id"], name: "index_follows_on_profile_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "hires", force: true do |t|
    t.integer  "person_id"
    t.string   "jobsearch",  default: "isee"
    t.string   "jobtype",    default: "isee"
    t.string   "paytype",    default: "isee"
    t.string   "loading"
    t.integer  "ratehour"
    t.integer  "ratemonth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hires", ["person_id"], name: "index_hires_on_person_id", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.string   "github"
    t.integer  "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "invites", ["profile_id"], name: "index_invites_on_profile_id", using: :btree

  create_table "news", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id",  default: 1
  end

  add_index "news", ["person_id"], name: "index_news_on_person_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "username"
    t.string   "firstname_ru"
    t.string   "lastname_ru"
    t.string   "city_ru"
    t.date     "dob"
    t.text     "about_ru"
    t.string   "email",              default: "anonymous@rubyhire.me"
    t.string   "url"
    t.string   "twitter"
    t.string   "github"
    t.string   "stackoverflow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "role",               default: "user"
    t.integer  "feedbackform",       default: 1
    t.integer  "subscribenews",      default: 1
    t.integer  "deleted",            default: 0
    t.date     "career"
    t.integer  "locked",             default: 0
    t.integer  "lastnews",           default: 0
    t.integer  "follows_count",      default: 0
    t.datetime "refreshed_at"
    t.string   "domain"
    t.integer  "impressions_count",  default: 0
    t.string   "firstname_en"
    t.string   "lastname_en"
    t.string   "city_en"
    t.text     "about_en"
  end

  create_table "pmessages", force: true do |t|
    t.integer  "person_id"
    t.string   "name"
    t.string   "email"
    t.string   "theme"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",       default: false
  end

  add_index "pmessages", ["person_id"], name: "index_pmessages_on_person_id", using: :btree

  create_table "repos", force: true do |t|
    t.integer  "person_id"
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "homepage"
    t.string   "language"
    t.integer  "fork"
    t.integer  "forks"
    t.integer  "watchers"
    t.datetime "created"
    t.datetime "pushed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repos", ["person_id"], name: "index_repos_on_person_id", using: :btree

  create_table "searches", force: true do |t|
    t.string   "jobsearch"
    t.string   "jobtype"
    t.string   "paytype"
    t.string   "loading"
    t.string   "ratehour_from"
    t.string   "ratehour_to"
    t.string   "ratemonth_from"
    t.string   "ratemonth_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", id: false, force: true do |t|
    t.string "name"
    t.string "abbrev"
  end

  add_index "states", ["abbrev"], name: "index_states_on_abbrev", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  add_index "taggings", ["tagger_type"], name: "index_taggings_on_tagger_type", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "team_projects", force: true do |t|
    t.integer  "team_id"
    t.string   "person_id"
    t.string   "name_ru"
    t.string   "name_en"
    t.text     "description_ru"
    t.text     "description_en"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "team_projects", ["person_id"], name: "index_team_projects_on_person_id", using: :btree
  add_index "team_projects", ["slug"], name: "index_team_projects_on_slug", unique: true, using: :btree
  add_index "team_projects", ["team_id"], name: "index_team_projects_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name_ru"
    t.string   "name_en"
    t.string   "slug"
    t.text     "description_ru"
    t.text     "description_en"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["person_id"], name: "index_teams_on_person_id", using: :btree
  add_index "teams", ["slug"], name: "index_teams_on_slug", unique: true, using: :btree

  create_table "works", force: true do |t|
    t.integer  "person_id"
    t.string   "name_ru"
    t.string   "slug"
    t.date     "start"
    t.date     "finish"
    t.text     "description_ru"
    t.string   "role_ru"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "mirror"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "name_en"
    t.text     "description_en"
    t.string   "role_en"
  end

  add_index "works", ["person_id"], name: "index_works_on_person_id", using: :btree

end

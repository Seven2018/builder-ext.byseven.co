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

ActiveRecord::Schema.define(version: 2019_06_23_144122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "description"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "title"
    t.text "role_description"
    t.bigint "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_company_id"], name: "index_client_contacts_on_client_company_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "object"
    t.text "content"
    t.bigint "user_id"
    t.bigint "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_comments_on_session_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.string "format"
    t.integer "duration"
    t.text "description"
    t.string "logistic"
    t.bigint "chapter_id"
    t.integer "intel1_id"
    t.integer "intel2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_contents_on_chapter_id"
  end

  create_table "intelligences", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_trainers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_session_trainers_on_session_id"
    t.index ["user_id"], name: "index_session_trainers_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.bigint "training_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_id"], name: "index_sessions_on_training_id"
  end

  create_table "theories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "links"
    t.text "references"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "theory_contents", force: :cascade do |t|
    t.bigint "theory_id"
    t.bigint "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_theory_contents_on_content_id"
    t.index ["theory_id"], name: "index_theory_contents_on_theory_id"
  end

  create_table "training_ownerships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "training_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_id"], name: "index_training_ownerships_on_training_id"
    t.index ["user_id"], name: "index_training_ownerships_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.integer "participant_number"
    t.bigint "client_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_contact_id"], name: "index_trainings_on_client_contact_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.string "access_level", default: "sevener", null: false
    t.string "picture"
    t.string "linkedin"
    t.text "description"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "title"
    t.string "format"
    t.integer "duration"
    t.text "description"
    t.bigint "session_id"
    t.string "logistic"
    t.bigint "chapter_id"
    t.integer "position"
    t.integer "intel1_id"
    t.integer "intel2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_workshops_on_chapter_id"
    t.index ["session_id"], name: "index_workshops_on_session_id"
  end

  add_foreign_key "client_contacts", "client_companies"
  add_foreign_key "comments", "sessions"
  add_foreign_key "comments", "users"
  add_foreign_key "contents", "chapters"
  add_foreign_key "session_trainers", "sessions"
  add_foreign_key "session_trainers", "users"
  add_foreign_key "sessions", "trainings"
  add_foreign_key "theory_contents", "contents"
  add_foreign_key "theory_contents", "theories"
  add_foreign_key "training_ownerships", "trainings"
  add_foreign_key "training_ownerships", "users"
  add_foreign_key "trainings", "client_contacts"
  add_foreign_key "workshops", "chapters"
  add_foreign_key "workshops", "sessions"
end

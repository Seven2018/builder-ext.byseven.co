# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_22_094637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "intelligence_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["intelligence_id"], name: "index_actions_on_intelligence_id"
  end

  create_table "content_modules", force: :cascade do |t|
    t.string "title"
    t.text "instructions"
    t.integer "duration"
    t.text "logistics"
    t.integer "action1_id"
    t.integer "action2_id"
    t.text "comments"
    t.integer "position"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_content_modules_on_content_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.integer "duration"
    t.text "description"
    t.bigint "theme_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["theme_id"], name: "index_contents_on_theme_id"
  end

  create_table "intelligences", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "session_trainers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "session_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_session_trainers_on_session_id"
    t.index ["user_id"], name: "index_session_trainers_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.float "duration"
    t.time "start_time"
    t.time "end_time"
    t.bigint "training_id"
    t.string "log"
    t.string "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_id"], name: "index_sessions_on_training_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "theories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "references"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "theory_contents", force: :cascade do |t|
    t.bigint "theory_id"
    t.bigint "content_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_theory_contents_on_content_id"
    t.index ["theory_id"], name: "index_theory_contents_on_theory_id"
  end

  create_table "theory_workshops", force: :cascade do |t|
    t.bigint "theory_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["theory_id"], name: "index_theory_workshops_on_theory_id"
    t.index ["workshop_id"], name: "index_theory_workshops_on_workshop_id"
  end

  create_table "training_ownerships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "training_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_id"], name: "index_training_ownerships_on_training_id"
    t.index ["user_id"], name: "index_training_ownerships_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "title"
    t.string "calendar_temp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "firstname", default: "", null: false
    t.string "lastname", default: "", null: false
    t.string "access_level", null: false
    t.string "picture"
    t.string "phone_number"
    t.string "address"
    t.string "linkedin"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshop_modules", force: :cascade do |t|
    t.string "title"
    t.text "instructions"
    t.integer "duration"
    t.text "logistics"
    t.integer "action1_id"
    t.integer "action2_id"
    t.text "comments"
    t.integer "position"
    t.bigint "user_id"
    t.bigint "workshop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_workshop_modules_on_user_id"
    t.index ["workshop_id"], name: "index_workshop_modules_on_workshop_id"
  end

  create_table "workshops", force: :cascade do |t|
    t.string "title"
    t.integer "duration"
    t.text "description"
    t.bigint "session_id"
    t.bigint "theme_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_workshops_on_session_id"
    t.index ["theme_id"], name: "index_workshops_on_theme_id"
  end

  add_foreign_key "actions", "intelligences"
  add_foreign_key "content_modules", "contents"
  add_foreign_key "contents", "themes"
  add_foreign_key "session_trainers", "sessions"
  add_foreign_key "session_trainers", "users"
  add_foreign_key "sessions", "trainings"
  add_foreign_key "theory_contents", "contents"
  add_foreign_key "theory_contents", "theories"
  add_foreign_key "theory_workshops", "theories"
  add_foreign_key "theory_workshops", "workshops"
  add_foreign_key "training_ownerships", "trainings"
  add_foreign_key "training_ownerships", "users"
  add_foreign_key "workshop_modules", "users"
  add_foreign_key "workshop_modules", "workshops"
  add_foreign_key "workshops", "sessions"
  add_foreign_key "workshops", "themes"
end

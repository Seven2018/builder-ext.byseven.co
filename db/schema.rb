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

ActiveRecord::Schema.define(version: 2019_07_03_132141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "intelligence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intelligence_id"], name: "index_actions_on_intelligence_id"
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "client_company_type"
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

  create_table "content_modules", force: :cascade do |t|
    t.string "title"
    t.text "instructions"
    t.integer "duration"
    t.string "url1"
    t.string "url2"
    t.string "image1"
    t.string "image2"
    t.text "logistics"
    t.integer "action1_id"
    t.integer "action2_id"
    t.text "comments"
    t.integer "position"
    t.bigint "content_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_content_modules_on_content_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.integer "duration"
    t.text "description"
    t.bigint "theme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theme_id"], name: "index_contents_on_theme_id"
  end

  create_table "intelligences", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "client_company_id"
    t.bigint "training_id"
    t.string "type"
    t.decimal "total_amount", precision: 15, scale: 10
    t.decimal "tax_amount", precision: 15, scale: 10
    t.string "status"
    t.string "identifier"
    t.string "description"
    t.datetime "issue_date"
    t.datetime "due_date"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_company_id"], name: "index_invoice_items_on_client_company_id"
    t.index ["training_id"], name: "index_invoice_items_on_training_id"
  end

  create_table "invoice_lines", force: :cascade do |t|
    t.string "description"
    t.integer "quantity"
    t.decimal "net_amount", precision: 15, scale: 10
    t.decimal "tax_amount", precision: 15, scale: 10
    t.bigint "invoice_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_item_id"], name: "index_invoice_lines_on_invoice_item_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 15, scale: 10
    t.integer "tax"
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

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "workshop_modules", force: :cascade do |t|
    t.string "title"
    t.text "instructions"
    t.integer "duration"
    t.string "url1"
    t.string "url2"
    t.string "image1"
    t.string "image2"
    t.text "logistics"
    t.integer "action1_id"
    t.integer "action2_id"
    t.text "comments"
    t.integer "position"
    t.bigint "user_id"
    t.bigint "workshop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_workshops_on_session_id"
    t.index ["theme_id"], name: "index_workshops_on_theme_id"
  end

  add_foreign_key "actions", "intelligences"
  add_foreign_key "client_contacts", "client_companies"
  add_foreign_key "comments", "sessions"
  add_foreign_key "comments", "users"
  add_foreign_key "content_modules", "contents"
  add_foreign_key "contents", "themes"
  add_foreign_key "invoice_items", "client_companies"
  add_foreign_key "invoice_items", "trainings"
  add_foreign_key "invoice_lines", "invoice_items"
  add_foreign_key "session_trainers", "sessions"
  add_foreign_key "session_trainers", "users"
  add_foreign_key "sessions", "trainings"
  add_foreign_key "theory_contents", "contents"
  add_foreign_key "theory_contents", "theories"
  add_foreign_key "training_ownerships", "trainings"
  add_foreign_key "training_ownerships", "users"
  add_foreign_key "trainings", "client_contacts"
  add_foreign_key "workshop_modules", "users"
  add_foreign_key "workshop_modules", "workshops"
  add_foreign_key "workshops", "sessions"
  add_foreign_key "workshops", "themes"
end

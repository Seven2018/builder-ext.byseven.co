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

ActiveRecord::Schema.define(version: 2020_03_20_110743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "actions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "intelligence1_id"
    t.integer "intelligence2_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "attendees", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "employee_id"
    t.string "email"
    t.bigint "client_company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_company_id"], name: "index_attendees_on_client_company_id"
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "client_company_type"
    t.text "description"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zipcode"
    t.string "city"
    t.string "reference"
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "title"
    t.text "role_description"
    t.bigint "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "billing_contact"
    t.string "billing_email"
    t.string "billing_address"
    t.string "billing_zipcode"
    t.string "billing_city"
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

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.bigint "training_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["training_id"], name: "index_forms_on_training_id"
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
    t.bigint "user_id"
    t.string "type"
    t.decimal "total_amount", precision: 15, scale: 10
    t.decimal "tax_amount", precision: 15, scale: 10
    t.string "status"
    t.string "description"
    t.datetime "sending_date"
    t.datetime "payment_date"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "dunning_date"
    t.index ["client_company_id"], name: "index_invoice_items_on_client_company_id"
    t.index ["training_id"], name: "index_invoice_items_on_training_id"
    t.index ["user_id"], name: "index_invoice_items_on_user_id"
  end

  create_table "invoice_lines", force: :cascade do |t|
    t.string "description"
    t.text "comments"
    t.float "quantity"
    t.decimal "net_amount", precision: 15, scale: 10
    t.decimal "tax_amount", precision: 15, scale: 10
    t.bigint "invoice_item_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["invoice_item_id"], name: "index_invoice_lines_on_invoice_item_id"
    t.index ["product_id"], name: "index_invoice_lines_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 15, scale: 10
    t.integer "tax"
    t.string "product_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
  end

  create_table "session_attendees", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.bigint "attendee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attendee_id"], name: "index_session_attendees_on_attendee_id"
    t.index ["session_id"], name: "index_session_attendees_on_session_id"
  end

  create_table "session_forms", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.bigint "form_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["form_id"], name: "index_session_forms_on_form_id"
    t.index ["session_id"], name: "index_session_forms_on_session_id"
  end

  create_table "session_trainers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "calendar_uuid"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendee_number"
    t.string "picture"
    t.text "description"
    t.text "teaser"
    t.string "image"
    t.string "address"
    t.string "room"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_id"], name: "index_training_ownerships_on_training_id"
    t.index ["user_id"], name: "index_training_ownerships_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.string "title"
    t.bigint "client_contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode"
    t.string "satisfaction_survey"
    t.string "refid"
    t.index ["client_contact_id"], name: "index_trainings_on_client_contact_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "firstname", default: "", null: false
    t.string "lastname", default: "", null: false
    t.boolean "english_fluent"
    t.string "access_level", default: "sevener", null: false
    t.string "picture"
    t.string "phone_number"
    t.string "address"
    t.string "linkedin"
    t.text "description"
    t.integer "rating"
    t.string "company_name"
    t.string "company_address"
    t.string "siret"
    t.boolean "vat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendees", "client_companies"
  add_foreign_key "client_contacts", "client_companies"
  add_foreign_key "comments", "sessions"
  add_foreign_key "comments", "users"
  add_foreign_key "content_modules", "contents"
  add_foreign_key "contents", "themes"
  add_foreign_key "forms", "trainings"
  add_foreign_key "invoice_items", "client_companies"
  add_foreign_key "invoice_items", "trainings"
  add_foreign_key "invoice_items", "users"
  add_foreign_key "invoice_lines", "invoice_items"
  add_foreign_key "invoice_lines", "products"
  add_foreign_key "session_attendees", "attendees"
  add_foreign_key "session_attendees", "sessions"
  add_foreign_key "session_forms", "forms"
  add_foreign_key "session_forms", "sessions"
  add_foreign_key "session_trainers", "sessions"
  add_foreign_key "session_trainers", "users"
  add_foreign_key "sessions", "trainings"
  add_foreign_key "theory_contents", "contents"
  add_foreign_key "theory_contents", "theories"
  add_foreign_key "theory_workshops", "theories"
  add_foreign_key "theory_workshops", "workshops"
  add_foreign_key "training_ownerships", "trainings"
  add_foreign_key "training_ownerships", "users"
  add_foreign_key "trainings", "client_contacts"
  add_foreign_key "workshop_modules", "users"
  add_foreign_key "workshop_modules", "workshops"
  add_foreign_key "workshops", "sessions"
  add_foreign_key "workshops", "themes"
end

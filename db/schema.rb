# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_12_000002) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "constructor_results", force: :cascade do |t|
    t.integer "race_id", null: false
    t.string "constructor"
    t.integer "position"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_constructor_results_on_race_id"
  end

  create_table "constructors", force: :cascade do |t|
    t.string "name"
    t.integer "base_price"
    t.decimal "current_rating"
    t.integer "current_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "championship_position"
    t.string "official_logo_url"
  end

  create_table "driver_results", force: :cascade do |t|
    t.integer "race_id", null: false
    t.string "driver"
    t.string "team"
    t.integer "position"
    t.integer "points"
    t.boolean "fastest_lap"
    t.boolean "dnf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_driver_results_on_race_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "team"
    t.integer "base_price"
    t.decimal "current_rating"
    t.integer "current_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "championship_position"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "circuit"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_selections", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "selectable_type", null: false
    t.integer "selectable_id", null: false
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["selectable_type", "selectable_id"], name: "index_team_selections_on_selectable"
    t.index ["team_id", "selectable_type", "selectable_id"], name: "index_team_selections_unique", unique: true
    t.index ["team_id"], name: "index_team_selections_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.integer "total_cost", null: false
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "status"], name: "index_teams_on_user_id_and_status"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "constructor_results", "races"
  add_foreign_key "driver_results", "races"
  add_foreign_key "team_selections", "teams"
  add_foreign_key "teams", "users"
end

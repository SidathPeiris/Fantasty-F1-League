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

ActiveRecord::Schema[8.0].define(version: 2025_08_06_100106) do
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
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "circuit"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "constructor_results", "races"
  add_foreign_key "driver_results", "races"
end

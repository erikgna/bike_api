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

ActiveRecord::Schema[7.0].define(version: 2023_06_24_174335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "payments", force: :cascade do |t|
    t.string "holder_name"
    t.string "card_number"
    t.string "expiration_date"
    t.string "ccv"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.string "value"
    t.string "creation_date"
    t.string "city"
    t.string "start_date"
    t.string "end_date"
    t.string "start_location"
    t.string "end_location"
    t.json "path"
    t.bigint "user_id", null: false
    t.bigint "payments_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payments_id"], name: "index_rides_on_payments_id"
    t.index ["user_id"], name: "index_rides_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "payments", "users"
  add_foreign_key "rides", "payments", column: "payments_id"
  add_foreign_key "rides", "users"
end

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

ActiveRecord::Schema[7.2].define(version: 2024_11_19_180834) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.decimal "base_price"
    t.decimal "minimum_cost"
    t.decimal "additional_cost_per_gram"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fee_percentage"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "collection_point_address"
  end

  create_table "packages", force: :cascade do |t|
    t.string "category"
    t.decimal "weight"
    t.decimal "cost"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.string "payment_method"
    t.integer "payment_status", default: 0
    t.string "tracking_number"
    t.string "collection_pin"
    t.integer "origin_city_id", null: false
    t.integer "destination_city_id", null: false
    t.decimal "amount"
    t.index ["destination_city_id"], name: "index_packages_on_destination_city_id"
    t.index ["origin_city_id"], name: "index_packages_on_origin_city_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "package_id"
    t.string "transaction_type"
    t.string "reference"
    t.string "for"
    t.string "Send"
    t.string "and"
    t.string "Collect"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "id_number"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "packages", "cities", column: "destination_city_id"
  add_foreign_key "packages", "cities", column: "origin_city_id"
end

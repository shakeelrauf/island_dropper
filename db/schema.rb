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

ActiveRecord::Schema.define(version: 20180910210203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.string "b_id"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "pre_order_date"
    t.bigint "user_id"
    t.string "state", default: "new"
    t.string "reference_no"
    t.string "tracking_url"
    t.boolean "priority", default: false
    t.boolean "pre_order", default: false
    t.string "checkout_response"
    t.string "stripe_transaction_id"
    t.index ["user_id"], name: "index_deliveries_on_user_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "driver_name"
    t.string "driver_location"
    t.integer "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_no"
    t.string "phone_number"
    t.string "email"
    t.string "photo_url"
  end

  create_table "dropoffs", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "phone_number"
    t.text "delivery_instructions"
    t.bigint "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "latitude"
    t.string "longitude"
    t.index ["delivery_id"], name: "index_dropoffs_on_delivery_id"
  end

  create_table "item_types", force: :cascade do |t|
    t.string "title"
    t.string "base_rate"
    t.string "per_km_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "size", default: "small"
    t.string "description"
    t.bigint "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_id"], name: "index_items_on_delivery_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "longitude"
    t.string "latitude"
    t.integer "delivery_id"
    t.string "when_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pickups", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "phone_number"
    t.integer "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "latitude"
    t.string "longitude"
  end

  create_table "priorities", force: :cascade do |t|
    t.float "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_foreign_key "deliveries", "users"
  add_foreign_key "dropoffs", "deliveries"
  add_foreign_key "items", "deliveries"
end

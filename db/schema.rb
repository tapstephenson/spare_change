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

ActiveRecord::Schema.define(version: 20150621232535) do

  create_table "banks", force: :cascade do |t|
    t.string   "bank_name"
    t.string   "account_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount",     precision: 10, scale: 2
    t.datetime "datetime"
    t.boolean  "pending"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "charities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "donations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "charity_id"
    t.decimal  "amount",     precision: 10, scale: 2
    t.datetime "datetime"
    t.boolean  "pending"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "charity_id"
    t.string   "transaction_account"
    t.string   "transaction_id"
    t.decimal  "amount",              precision: 10, scale: 2
    t.decimal  "rounded_amount",      precision: 10, scale: 2
    t.decimal  "difference",          precision: 10, scale: 2
    t.date     "date"
    t.string   "name"
    t.boolean  "pending"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "charity_id"
    t.integer  "bank_id"
    t.string   "plaid_access_token"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

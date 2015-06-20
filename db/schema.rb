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

ActiveRecord::Schema.define(version: 20150619191943) do

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
    t.string   "paypal_id"
    t.text     "description"
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
    t.date     "date"
    t.string   "name"
    t.boolean  "pending"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "password_hash"
    t.string   "account_type"
    t.integer  "charity_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end

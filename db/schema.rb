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

ActiveRecord::Schema.define(version: 2018_10_10_062826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.uuid "budget_id"
    t.uuid "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_accounts_on_budget_id"
    t.index ["collection_id"], name: "index_accounts_on_collection_id"
  end

  create_table "budgets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "ext_id"
    t.uuid "source_id"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_collections_on_source_id"
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.uuid "collection_id"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_items_on_collection_id"
  end

  create_table "sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.uuid "user_id"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "ext_id"
    t.string "state"
    t.boolean "approved"
    t.datetime "date"
    t.jsonb "properties"
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "ynab_access_token"
    t.jsonb "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "budgets"
  add_foreign_key "accounts", "collections"
  add_foreign_key "budgets", "users"
  add_foreign_key "collections", "sources"
  add_foreign_key "items", "collections"
  add_foreign_key "sources", "users"
  add_foreign_key "transactions", "accounts"
end

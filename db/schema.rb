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

ActiveRecord::Schema[7.2].define(version: 2025_02_25_082849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "cheerings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_cheerings_on_goal_id"
    t.index ["user_id"], name: "index_cheerings_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "description", null: false
    t.integer "progress", default: 0, null: false
    t.integer "likings_count", default: 0, null: false
    t.integer "cheerings_count", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "reward_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_goals_on_reward_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "likings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_likings_on_goal_id"
    t.index ["user_id"], name: "index_likings_on_user_id"
  end

  create_table "reward_participants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "reward_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_reward_participants_on_reward_id"
    t.index ["user_id", "reward_id"], name: "index_reward_participants_on_user_id_and_reward_id", unique: true
    t.index ["user_id"], name: "index_reward_participants_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "description", null: false
    t.string "location", null: false
    t.date "completion_date", null: false
    t.string "invitation_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completion_date"], name: "index_rewards_on_completion_date"
    t.index ["invitation_token"], name: "index_rewards_on_invitation_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cheerings", "goals"
  add_foreign_key "cheerings", "users"
  add_foreign_key "goals", "rewards"
  add_foreign_key "goals", "users"
  add_foreign_key "likings", "goals"
  add_foreign_key "likings", "users"
  add_foreign_key "reward_participants", "rewards"
  add_foreign_key "reward_participants", "users"
end

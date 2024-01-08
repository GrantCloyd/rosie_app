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

ActiveRecord::Schema[7.1].define(version: 2023_12_16_195651) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id"
    t.text "note"
    t.string "target_email", null: false
    t.integer "status", default: 0
    t.integer "role_tier", default: 0
    t.integer "privacy_tier", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invites_on_group_id"
    t.index ["status"], name: "index_invites_on_status"
    t.index ["target_email", "group_id"], name: "index_invites_on_target_email_and_group_id", unique: true
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.integer "status", default: 0
    t.bigint "section_id", null: false
    t.bigint "user_group_section_id", null: false
    t.datetime "published_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_posts_on_section_id"
    t.index ["user_group_section_id"], name: "index_posts_on_user_group_section_id"
  end

  create_table "section_role_permissions", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.integer "role_tier", null: false
    t.integer "permission_level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id", "role_tier"], name: "index_section_role_permissions_on_section_id_and_role_tier", unique: true
    t.index ["section_id"], name: "index_section_role_permissions_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "status", default: 0, null: false
    t.integer "privacy_tier", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_sections_on_group_id"
    t.index ["status"], name: "index_sections_on_status"
    t.index ["user_id"], name: "index_sections_on_user_id"
  end

  create_table "user_group_sections", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "user_group_id", null: false
    t.integer "permission_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_user_group_sections_on_section_id"
    t.index ["user_group_id", "section_id"], name: "index_user_group_sections_on_user_group_id_and_section_id", unique: true
    t.index ["user_group_id"], name: "index_user_group_sections_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.integer "privacy_tier", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id", "group_id"], name: "index_user_groups_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "moderator_email_notifications", default: true
    t.boolean "subscriber_email_notifications", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id", unique: true
  end

  create_table "user_reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", null: false
    t.string "reactionable_type", null: false
    t.bigint "reactionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactionable_type", "reactionable_id"], name: "index_user_reactions_on_reactionable"
    t.index ["status"], name: "index_user_reactions_on_status"
    t.index ["user_id"], name: "index_user_reactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "users"
  add_foreign_key "invites", "groups"
  add_foreign_key "invites", "users"
  add_foreign_key "posts", "sections"
  add_foreign_key "posts", "user_group_sections"
  add_foreign_key "section_role_permissions", "sections"
  add_foreign_key "sections", "groups"
  add_foreign_key "sections", "users"
  add_foreign_key "user_group_sections", "sections"
  add_foreign_key "user_group_sections", "user_groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "user_reactions", "users"
end

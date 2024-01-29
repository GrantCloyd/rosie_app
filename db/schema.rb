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

ActiveRecord::Schema[7.1].define(version: 2024_01_29_144757) do
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

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
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
    t.string "slug", null: false
    t.integer "status", default: 0
    t.integer "pin_index"
    t.bigint "section_id", null: false
    t.bigint "user_id", null: false
    t.datetime "published_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pin_index"], name: "index_posts_on_pin_index"
    t.index ["section_id"], name: "index_posts_on_section_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
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
    t.string "slug", null: false
    t.text "description", null: false
    t.integer "status", default: 0, null: false
    t.integer "privacy_tier", default: 0, null: false
    t.integer "pin_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_sections_on_group_id"
    t.index ["pin_index"], name: "index_sections_on_pin_index"
    t.index ["status"], name: "index_sections_on_status"
    t.index ["user_id"], name: "index_sections_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "kind", null: false
    t.bigint "user_id", null: false
    t.string "code", null: false
    t.datetime "expires_at", null: false
    t.index ["code"], name: "index_tokens_on_code", unique: true
    t.index ["expires_at"], name: "index_tokens_on_expires_at"
    t.index ["kind", "user_id"], name: "index_tokens_on_kind_and_user_id", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
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
  add_foreign_key "posts", "users"
  add_foreign_key "section_role_permissions", "sections"
  add_foreign_key "sections", "groups"
  add_foreign_key "sections", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_group_sections", "sections"
  add_foreign_key "user_group_sections", "user_groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "user_reactions", "users"
end

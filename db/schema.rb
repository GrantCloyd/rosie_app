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

ActiveRecord::Schema[7.1].define(version: 2023_11_18_144018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content", null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "user_id"
    t.text "note"
    t.string "target_email", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_invitations_on_topic_id", unique: true
    t.index ["user_id"], name: "index_invitations_on_user_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.text "content", null: false
    t.integer "status", default: 0
    t.bigint "topics_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topics_id"], name: "index_posts_on_topics_id", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "status", default: 0
    t.bigint "moderator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moderator_id"], name: "index_topics_on_moderator_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "moderator_email_notifications", default: true
    t.boolean "subscriber_email_notifications", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id", unique: true
  end

  create_table "user_reactions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "reaction_status", null: false
    t.string "reactionable_type"
    t.bigint "reactionable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactionable_type", "reactionable_id"], name: "index_user_reactions_on_reactionable"
    t.index ["user_id"], name: "index_user_reactions_on_user_id", unique: true
  end

  create_table "user_topics", force: :cascade do |t|
    t.integer "role", null: false
    t.bigint "user_id"
    t.bigint "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_user_topics_on_topic_id", unique: true
    t.index ["user_id"], name: "index_user_topics_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "users"
  add_foreign_key "invitations", "topics"
  add_foreign_key "invitations", "users"
  add_foreign_key "posts", "topics", column: "topics_id"
  add_foreign_key "topics", "user_topics", column: "moderator_id"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "user_reactions", "users"
end

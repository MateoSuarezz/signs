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

ActiveRecord::Schema[7.0].define(version: 2023_09_19_142338) do
  create_table "cards", force: :cascade do |t|
    t.string "description"
    t.string "content_link"
  end

  create_table "modules", force: :cascade do |t|
    t.string "name"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.string "password"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "answer"
    t.string "question"
    t.string "content_link"
    t.integer "module_id"
  end

  create_table "responses", force: :cascade do |t|
    t.integer "users_id", null: false
    t.integer "questions_id", null: false
    t.boolean "correct_answer", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questions_id"], name: "index_responses_on_questions_id"
    t.index ["users_id"], name: "index_responses_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "responses", "questions", column: "questions_id"
  add_foreign_key "responses", "users", column: "users_id"
end

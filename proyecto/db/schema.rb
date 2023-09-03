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

ActiveRecord::Schema[7.0].define(version: 2023_06_02_143715) do
  create_table "assessments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "correct_answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_assessments_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "description"
    t.string "content_link"
  end

  create_table "modules", force: :cascade do |t|
    t.string "name"
    t.integer "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person", force: :cascade do |t|
    t.string "name"
    t.string "mail"
    t.string "password"
  end

  create_table "question", force: :cascade do |t|
    t.integer "question"
    t.boolean "answer"
    t.integer "module_id"
  end

end

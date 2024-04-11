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

ActiveRecord::Schema[7.1].define(version: 2024_04_09_062441) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comment", id: :bigint, default: -> { "nextval('\"Comment_id_seq\"'::regclass)" }, force: :cascade do |t|
    t.string "feacture_id"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "earthquakes", force: :cascade do |t|
    t.float "mag"
    t.string "place"
    t.datetime "time"
    t.string "url"
    t.integer "tsunami"
    t.string "mag_type"
    t.string "title"
    t.float "longitude"
    t.float "latitude"
    t.string "feacture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

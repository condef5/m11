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

ActiveRecord::Schema[7.1].define(version: 2023_12_01_065731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "answers", id: false, force: :cascade do |t|
    t.bigint "id", null: false
    t.bigint "survey_id", null: false
    t.bigint "question_id", null: false
    t.integer "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_days", force: :cascade do |t|
    t.text "player_list"
    t.integer "players_per_team", default: 7
    t.integer "generation_attempts", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "teams", default: [], null: false
  end

  create_table "player_connections", force: :cascade do |t|
    t.integer "relation_type"
    t.bigint "author_id", null: false
    t.bigint "connected_player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "connected_player_id"], name: "unique_player_connection_index", unique: true
    t.index ["author_id"], name: "index_player_connections_on_author_id"
    t.index ["connected_player_id"], name: "index_player_connections_on_connected_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["name"], name: "index_players_on_name"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "username"
    t.string "image"
    t.string "birthdate"
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "unique_usernames", unique: true
  end

  add_foreign_key "player_connections", "players", column: "author_id"
  add_foreign_key "player_connections", "players", column: "connected_player_id"
  add_foreign_key "players", "users"
end

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

ActiveRecord::Schema.define(version: 20170313191655) do

  create_table "cancellations", force: true do |t|
    t.string   "year",                                              null: false
    t.integer  "user_id",                                           null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "primaryphone"
    t.string   "secondaryphone"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.boolean  "firsttime",               default: false
    t.boolean  "mailinglist",             default: true
    t.boolean  "donotpublish",            default: false
    t.boolean  "dorm",                    default: true
    t.string   "share_housing_with"
    t.boolean  "meals",                   default: true
    t.boolean  "vegetarian",              default: false
    t.string   "gender",                  default: "F"
    t.boolean  "participant",             default: true
    t.integer  "instrument_id"
    t.boolean  "monday",                  default: false
    t.integer  "tshirtm",                 default: 0
    t.integer  "tshirtl",                 default: 0
    t.integer  "tshirtxl",                default: 0
    t.integer  "tshirtxxl",               default: 0
    t.boolean  "discount",                default: false
    t.integer  "donation",                default: 0
    t.text     "comments"
    t.boolean  "aircond",                 default: false
    t.string   "payment_mode",            default: "deposit_check"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registration_id"
    t.string   "country",                 default: "US"
  end

  create_table "cancelled_payments", force: true do |t|
    t.integer  "registration_id",                                         null: false
    t.decimal  "amount",          precision: 8, scale: 2,                 null: false
    t.string   "check_number"
    t.string   "note"
    t.date     "date_received"
    t.boolean  "scholarship",                             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id",                                              null: false
    t.boolean  "online",                                  default: false
    t.string   "confirmed"
  end

  create_table "downloads", force: true do |t|
    t.string   "download_type"
    t.datetime "downloaded_at"
  end

  create_table "electives", force: true do |t|
    t.string   "name"
    t.string   "instructor"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "electives_instruments", id: false, force: true do |t|
    t.integer "elective_id",   null: false
    t.integer "instrument_id", null: false
  end

  add_index "electives_instruments", ["elective_id", "instrument_id"], name: "index_electives_instruments_on_elective_id_and_instrument_id", using: :btree
  add_index "electives_instruments", ["instrument_id", "elective_id"], name: "index_electives_instruments_on_instrument_id_and_elective_id", using: :btree

  create_table "ensemble_primaries", force: true do |t|
    t.integer  "registration_id"
    t.integer  "large_ensemble_choice"
    t.integer  "chamber_ensemble_choice"
    t.integer  "large_ensemble_part"
    t.boolean  "want_sing_in_chorus"
    t.boolean  "want_percussion_in_band"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
  end

  create_table "ensemble_primary_elective_ranks", force: true do |t|
    t.integer  "ensemble_primary_id"
    t.integer  "elective_id"
    t.integer  "instrument_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evaluations", force: true do |t|
    t.integer  "ensemble_primary_id"
    t.integer  "instrument_id"
    t.string   "type"
    t.integer  "chamber_ensemble_part"
    t.boolean  "transposition_0"
    t.boolean  "transposition_1"
    t.boolean  "transposition_2"
    t.boolean  "other_instrument_oboe"
    t.boolean  "other_instrument_english_horn"
    t.boolean  "other_instrument_oboe_other"
    t.boolean  "other_instrument_trombone"
    t.boolean  "other_instrument_bass_trombone"
    t.boolean  "other_instrument_bb_trumpet"
    t.boolean  "other_instrument_c_trumpet"
    t.boolean  "other_instrument_piccolo_trumpet"
    t.boolean  "other_instrument_saxophone_soprano"
    t.boolean  "other_instrument_saxophone_alto"
    t.boolean  "other_instrument_saxophone_tenor"
    t.boolean  "other_instrument_saxophone_baritone"
    t.boolean  "other_instrument_bb_clarinet"
    t.boolean  "other_instrument_a_clarinet"
    t.boolean  "other_instrument_eb_clarinet"
    t.boolean  "other_instrument_alto_clarinet"
    t.boolean  "other_instrument_bass_clarinet"
    t.boolean  "other_instrument_c_flute"
    t.boolean  "other_instrument_piccolo"
    t.boolean  "other_instrument_alto_flute"
    t.boolean  "other_instrument_bass_flute"
    t.boolean  "other_instrument_drum_set"
    t.boolean  "other_instrument_mallets"
    t.boolean  "other_instrument_bassoon_contrabassoon"
    t.text     "other_instruments_you_tell_us"
    t.boolean  "percussion_snare"
    t.boolean  "percussion_timpani"
    t.boolean  "percussion_mallets"
    t.boolean  "percussion_small_instruments"
    t.boolean  "percussion_drum_set"
    t.text     "groups"
    t.boolean  "require_audition"
    t.boolean  "studying_privately"
    t.string   "studying_privately_how_long"
    t.integer  "chamber_music_how_often"
    t.integer  "practicing_how_much"
    t.string   "composers"
    t.boolean  "jazz_want_ensemble"
    t.boolean  "jazz_small_ensemble"
    t.boolean  "jazz_big_band"
    t.integer  "vocal_low_high"
    t.string   "vocal_overall_ability"
    t.integer  "vocal_how_learn"
    t.string   "vocal_most_difficult_piece"
    t.boolean  "vocal_music_theory"
    t.string   "vocal_music_theory_year"
    t.boolean  "vocal_voice_class"
    t.string   "vocal_voice_class_year"
    t.boolean  "vocal_voice_lessons"
    t.string   "vocal_voice_lessons_year"
    t.string   "vocal_small_ensemble_skills"
    t.boolean  "third_position"
    t.boolean  "fourth_position"
    t.boolean  "fifth_position"
    t.boolean  "sixth_position"
    t.boolean  "seventh_position"
    t.boolean  "thumb_position"
    t.integer  "overall_rating_large_ensemble"
    t.integer  "overall_rating_chamber"
    t.integer  "overall_rating_sightreading"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instruments", force: true do |t|
    t.string   "display_name"
    t.string   "large_ensemble"
    t.string   "instrument_type"
    t.boolean  "closed",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitees", force: true do |t|
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sent"
  end

  create_table "mass_emails", force: true do |t|
    t.string   "email_address"
    t.string   "url_code"
    t.datetime "bounced_at"
    t.datetime "unsubscribed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mmr_chambers", force: true do |t|
    t.integer  "ensemble_primary_id"
    t.integer  "instrument_id"
    t.boolean  "string_novice"
    t.boolean  "jazz_ensemble"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "registration_id",                                         null: false
    t.decimal  "amount",          precision: 8, scale: 2,                 null: false
    t.string   "check_number"
    t.string   "note"
    t.date     "date_received"
    t.boolean  "scholarship",                             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmed",                               default: "1"
    t.boolean  "online",                                  default: false
  end

  create_table "prearranged_chambers", force: true do |t|
    t.integer  "ensemble_primary_id"
    t.string   "group_name"
    t.boolean  "i_am_contact"
    t.string   "contact_name"
    t.string   "contact_email"
    t.integer  "instrument_id"
    t.text     "participant_names"
    t.boolean  "bring_own_music"
    t.string   "music_composer_and_name"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.string   "year",                                                            null: false
    t.integer  "user_id",                                                         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "primaryphone"
    t.string   "secondaryphone"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.boolean  "firsttime",                             default: false
    t.boolean  "mailinglist",                           default: true
    t.boolean  "donotpublish",                          default: false
    t.boolean  "dorm",                                  default: true
    t.string   "dorm_selection",              limit: 1
    t.string   "share_housing_with"
    t.boolean  "meals",                                 default: true
    t.boolean  "meals_lunch_and_dinner_only",           default: false
    t.boolean  "vegetarian",                            default: false
    t.string   "meals_selection",             limit: 1
    t.string   "gender",                                default: "F"
    t.boolean  "participant",                           default: true
    t.integer  "instrument_id"
    t.boolean  "monday",                                default: false
    t.integer  "tshirtm",                               default: 0
    t.integer  "tshirtl",                               default: 0
    t.integer  "tshirtxl",                              default: 0
    t.integer  "tshirtxxl",                             default: 0
    t.boolean  "discount",                              default: false
    t.integer  "donation",                              default: 0
    t.text     "comments"
    t.boolean  "aircond",                               default: false
    t.string   "payment_mode",                          default: "deposit_check"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country",                               default: "USA"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.boolean  "handicapped_access",                    default: false
    t.boolean  "airport_pickup",                        default: false
    t.boolean  "fan",                                   default: false
    t.boolean  "sunday",                                default: false
    t.integer  "wine_glasses",                          default: 0
    t.integer  "tshirts",                               default: 0
    t.integer  "tshirtxxxl",                            default: 0
    t.string   "occupation",                            default: ""
    t.boolean  "single_room",                           default: false
    t.string   "dorm_assignment"
    t.boolean  "minor_volunteer"
  end

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           null: false
    t.boolean  "admin",           default: false
    t.string   "hashed_password",                 null: false
    t.string   "salt",                            null: false
    t.boolean  "board",           default: false
    t.boolean  "registrar",       default: false
    t.time     "bounced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_id"
    t.boolean  "staff",           default: false
    t.boolean  "faculty",         default: false
    t.boolean  "test",            default: false
    t.boolean  "major_volunteer", default: false
  end

end

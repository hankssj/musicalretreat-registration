class CreateDatabase < ActiveRecord::Migration
  def self.up
    ActiveRecord::Schema.define(version: 20111126142511) do
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

      create_table "events", force: true do |t|
        t.string   "note"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "invitees", force: true do |t|
        t.string   "email",      null: false
        t.datetime "created_at"
        t.datetime "updated_at"
        t.boolean  "sent"
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
      end
    end
  end

  def self.down
    drop_table "cancellations";
    drop_table "cancelled_payments";
    drop_table "downloads";
    drop_table "events";
    drop_table "instruments";
    drop_table "invitees";
    drop_table "payments";
    drop_table "registrations";
    drop_table "schema_info";
    drop_table "sessions";
    drop_table "users";
  end
end

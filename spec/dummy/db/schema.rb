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

ActiveRecord::Schema.define(version: 20130519065837) do

  create_table "agent_relationship_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agent_relationships", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.integer  "agent_relationship_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "agent_relationships", ["child_id"], name: "index_agent_relationships_on_child_id"
  add_index "agent_relationships", ["parent_id"], name: "index_agent_relationships_on_parent_id"

  create_table "agent_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agents", force: true do |t|
    t.integer  "user_id"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "first_name"
    t.string   "last_name_transcription"
    t.string   "middle_name_transcription"
    t.string   "first_name_transcription"
    t.string   "corporate_name"
    t.string   "corporate_name_transcription"
    t.string   "full_name"
    t.text     "full_name_transcription"
    t.text     "full_name_alternative"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "zip_code_1"
    t.string   "zip_code_2"
    t.text     "address_1"
    t.text     "address_2"
    t.text     "address_1_note"
    t.text     "address_2_note"
    t.string   "telephone_number_1"
    t.string   "telephone_number_2"
    t.string   "fax_number_1"
    t.string   "fax_number_2"
    t.text     "other_designation"
    t.text     "place"
    t.string   "postal_code"
    t.text     "street"
    t.text     "locality"
    t.text     "region"
    t.datetime "date_of_birth"
    t.datetime "date_of_death"
    t.integer  "language_id",                         default: 1, null: false
    t.integer  "country_id",                          default: 1, null: false
    t.integer  "agent_type_id",                       default: 1, null: false
    t.integer  "lock_version",                        default: 0, null: false
    t.text     "note"
    t.integer  "creates_count",                       default: 0, null: false
    t.integer  "realizes_count",                      default: 0, null: false
    t.integer  "produces_count",                      default: 0, null: false
    t.integer  "owns_count",                          default: 0, null: false
    t.integer  "required_role_id",                    default: 1, null: false
    t.integer  "required_score",                      default: 0, null: false
    t.string   "state"
    t.text     "email"
    t.text     "url"
    t.text     "full_name_alternative_transcription"
    t.string   "birth_date"
    t.string   "death_date"
  end

  add_index "agents", ["country_id"], name: "index_agents_on_country_id"
  add_index "agents", ["full_name"], name: "index_agents_on_full_name"
  add_index "agents", ["language_id"], name: "index_agents_on_language_id"
  add_index "agents", ["required_role_id"], name: "index_agents_on_required_role_id"
  add_index "agents", ["user_id"], name: "index_agents_on_user_id", unique: true

  create_table "baskets", force: true do |t|
    t.integer  "user_id"
    t.text     "note"
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "baskets", ["user_id"], name: "index_baskets_on_user_id"

  create_table "carrier_type_has_checkout_types", force: true do |t|
    t.integer  "carrier_type_id",  null: false
    t.integer  "checkout_type_id", null: false
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carrier_type_has_checkout_types", ["carrier_type_id"], name: "index_carrier_type_has_checkout_types_on_m_form_id"
  add_index "carrier_type_has_checkout_types", ["checkout_type_id"], name: "index_carrier_type_has_checkout_types_on_checkout_type_id"

  create_table "carrier_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checked_items", force: true do |t|
    t.integer  "item_id",      null: false
    t.integer  "basket_id",    null: false
    t.datetime "due_date",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "librarian_id"
  end

  add_index "checked_items", ["basket_id"], name: "index_checked_items_on_basket_id"
  add_index "checked_items", ["item_id"], name: "index_checked_items_on_item_id"

  create_table "checkins", force: true do |t|
    t.integer  "item_id",                  null: false
    t.integer  "librarian_id"
    t.integer  "basket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", default: 0, null: false
  end

  add_index "checkins", ["basket_id"], name: "index_checkins_on_basket_id"
  add_index "checkins", ["item_id"], name: "index_checkins_on_item_id"
  add_index "checkins", ["librarian_id"], name: "index_checkins_on_librarian_id"

  create_table "checkout_stat_has_manifestations", force: true do |t|
    t.integer  "manifestation_checkout_stat_id", null: false
    t.integer  "manifestation_id",               null: false
    t.integer  "checkouts_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkout_stat_has_manifestations", ["manifestation_checkout_stat_id"], name: "index_checkout_stat_has_manifestations_on_checkout_stat_id"
  add_index "checkout_stat_has_manifestations", ["manifestation_id"], name: "index_checkout_stat_has_manifestations_on_manifestation_id"

  create_table "checkout_stat_has_users", force: true do |t|
    t.integer  "user_checkout_stat_id",             null: false
    t.integer  "user_id",                           null: false
    t.integer  "checkouts_count",       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkout_stat_has_users", ["user_checkout_stat_id"], name: "index_checkout_stat_has_users_on_user_checkout_stat_id"
  add_index "checkout_stat_has_users", ["user_id"], name: "index_checkout_stat_has_users_on_user_id"

  create_table "checkout_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkout_types", ["name"], name: "index_checkout_types_on_name"

  create_table "checkouts", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id",                            null: false
    t.integer  "checkin_id"
    t.integer  "librarian_id"
    t.integer  "basket_id"
    t.datetime "due_date"
    t.integer  "checkout_renewal_count", default: 0, null: false
    t.integer  "lock_version",           default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkouts", ["basket_id"], name: "index_checkouts_on_basket_id"
  add_index "checkouts", ["checkin_id"], name: "index_checkouts_on_checkin_id"
  add_index "checkouts", ["item_id", "basket_id"], name: "index_checkouts_on_item_id_and_basket_id", unique: true
  add_index "checkouts", ["item_id"], name: "index_checkouts_on_item_id"
  add_index "checkouts", ["librarian_id"], name: "index_checkouts_on_librarian_id"
  add_index "checkouts", ["user_id"], name: "index_checkouts_on_user_id"

  create_table "circulation_statuses", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string  "name",         null: false
    t.text    "display_name"
    t.string  "alpha_2"
    t.string  "alpha_3"
    t.string  "numeric_3"
    t.text    "note"
    t.integer "position"
  end

  add_index "countries", ["alpha_2"], name: "index_countries_on_alpha_2"
  add_index "countries", ["alpha_3"], name: "index_countries_on_alpha_3"
  add_index "countries", ["name"], name: "index_countries_on_name"
  add_index "countries", ["numeric_3"], name: "index_countries_on_numeric_3"

  create_table "create_types", force: true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creates", force: true do |t|
    t.integer  "agent_id",       null: false
    t.integer  "work_id",        null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "create_type_id"
  end

  add_index "creates", ["agent_id"], name: "index_creates_on_agent_id"
  add_index "creates", ["work_id"], name: "index_creates_on_work_id"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "donates", force: true do |t|
    t.integer  "agent_id",   null: false
    t.integer  "item_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donates", ["agent_id"], name: "index_donates_on_agent_id"
  add_index "donates", ["item_id"], name: "index_donates_on_item_id"

  create_table "event_categories", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "library_id",        default: 1,     null: false
    t.integer  "event_category_id", default: 1,     null: false
    t.string   "name"
    t.text     "note"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",           default: false, null: false
    t.datetime "deleted_at"
    t.text     "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_category_id"], name: "index_events_on_event_category_id"
  add_index "events", ["library_id"], name: "index_events_on_library_id"

  create_table "exemplifies", force: true do |t|
    t.integer  "manifestation_id", null: false
    t.integer  "item_id",          null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exemplifies", ["item_id"], name: "index_exemplifies_on_item_id", unique: true
  add_index "exemplifies", ["manifestation_id"], name: "index_exemplifies_on_manifestation_id"

  create_table "identifier_types", force: true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identifiers", force: true do |t|
    t.string   "body",               null: false
    t.integer  "identifier_type_id", null: false
    t.integer  "manifestation_id"
    t.boolean  "primary"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identifiers", ["body", "identifier_type_id"], name: "index_identifiers_on_body_and_identifier_type_id"
  add_index "identifiers", ["manifestation_id"], name: "index_identifiers_on_manifestation_id"

  create_table "item_has_use_restrictions", force: true do |t|
    t.integer  "item_id",            null: false
    t.integer  "use_restriction_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_has_use_restrictions", ["item_id"], name: "index_item_has_use_restrictions_on_item_id"
  add_index "item_has_use_restrictions", ["use_restriction_id"], name: "index_item_has_use_restrictions_on_use_restriction_id"

  create_table "items", force: true do |t|
    t.string   "call_number"
    t.string   "item_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "shelf_id",                    default: 1,     null: false
    t.boolean  "include_supplements",         default: false, null: false
    t.integer  "checkouts_count",             default: 0,     null: false
    t.integer  "owns_count",                  default: 0,     null: false
    t.integer  "resource_has_subjects_count", default: 0,     null: false
    t.text     "note"
    t.string   "url"
    t.integer  "price"
    t.integer  "lock_version",                default: 0,     null: false
    t.integer  "required_role_id",            default: 1,     null: false
    t.string   "state"
    t.integer  "required_score",              default: 0,     null: false
    t.datetime "acquired_at"
    t.integer  "circulation_status_id",       default: 5,     null: false
    t.integer  "checkout_type_id",            default: 1,     null: false
  end

  add_index "items", ["checkout_type_id"], name: "index_items_on_checkout_type_id"
  add_index "items", ["circulation_status_id"], name: "index_items_on_circulation_status_id"
  add_index "items", ["item_identifier"], name: "index_items_on_item_identifier"
  add_index "items", ["required_role_id"], name: "index_items_on_required_role_id"
  add_index "items", ["shelf_id"], name: "index_items_on_shelf_id"

  create_table "languages", force: true do |t|
    t.string  "name",         null: false
    t.string  "native_name"
    t.text    "display_name"
    t.string  "iso_639_1"
    t.string  "iso_639_2"
    t.string  "iso_639_3"
    t.text    "note"
    t.integer "position"
  end

  add_index "languages", ["iso_639_1"], name: "index_languages_on_iso_639_1"
  add_index "languages", ["iso_639_2"], name: "index_languages_on_iso_639_2"
  add_index "languages", ["iso_639_3"], name: "index_languages_on_iso_639_3"
  add_index "languages", ["name"], name: "index_languages_on_name", unique: true

  create_table "lending_policies", force: true do |t|
    t.integer  "item_id",                    null: false
    t.integer  "user_group_id",              null: false
    t.integer  "loan_period",    default: 0, null: false
    t.datetime "fixed_due_date"
    t.integer  "renewal",        default: 0, null: false
    t.integer  "fine",           default: 0, null: false
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lending_policies", ["item_id", "user_group_id"], name: "index_lending_policies_on_item_id_and_user_group_id", unique: true

  create_table "libraries", force: true do |t|
    t.integer  "agent_id"
    t.string   "agent_type"
    t.string   "name",                                null: false
    t.text     "display_name"
    t.string   "short_display_name",                  null: false
    t.string   "zip_code"
    t.text     "street"
    t.text     "locality"
    t.text     "region"
    t.string   "telephone_number_1"
    t.string   "telephone_number_2"
    t.string   "fax_number"
    t.text     "note"
    t.integer  "call_number_rows",      default: 1,   null: false
    t.string   "call_number_delimiter", default: "|", null: false
    t.integer  "library_group_id",      default: 1,   null: false
    t.integer  "users_count",           default: 0,   null: false
    t.integer  "position"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "isil"
  end

  add_index "libraries", ["agent_id"], name: "index_libraries_on_agent_id", unique: true
  add_index "libraries", ["library_group_id"], name: "index_libraries_on_library_group_id"
  add_index "libraries", ["name"], name: "index_libraries_on_name", unique: true

  create_table "library_groups", force: true do |t|
    t.string   "name",                                                           null: false
    t.text     "display_name"
    t.string   "short_name",                                                     null: false
    t.string   "email"
    t.text     "my_networks"
    t.text     "login_banner"
    t.text     "note"
    t.integer  "valid_period_for_new_user",   default: 365,                      null: false
    t.boolean  "post_to_union_catalog",       default: false,                    null: false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "admin_networks"
    t.boolean  "allow_bookmark_external_url", default: false,                    null: false
    t.integer  "position"
    t.string   "url",                         default: "http://localhost:3000/"
  end

  add_index "library_groups", ["short_name"], name: "index_library_groups_on_short_name"

  create_table "manifestation_checkout_stats", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "note"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "manifestation_checkout_stats", ["state"], name: "index_manifestation_checkout_stats_on_state"

  create_table "manifestation_relationship_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manifestation_relationships", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.integer  "manifestation_relationship_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "manifestation_relationships", ["child_id"], name: "index_manifestation_relationships_on_child_id"
  add_index "manifestation_relationships", ["parent_id"], name: "index_manifestation_relationships_on_parent_id"

  create_table "manifestation_reserve_stats", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "note"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "manifestation_reserve_stats", ["state"], name: "index_manifestation_reserve_stats_on_state"

  create_table "manifestations", force: true do |t|
    t.text     "original_title",                                  null: false
    t.text     "title_alternative"
    t.text     "title_transcription"
    t.string   "classification_number"
    t.string   "manifestation_identifier"
    t.datetime "date_of_publication"
    t.datetime "date_copyrighted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "access_address"
    t.integer  "language_id",                     default: 1,     null: false
    t.integer  "carrier_type_id",                 default: 1,     null: false
    t.integer  "extent_id",                       default: 1,     null: false
    t.integer  "start_page"
    t.integer  "end_page"
    t.integer  "height"
    t.integer  "width"
    t.integer  "depth"
    t.string   "isbn"
    t.string   "isbn10"
    t.string   "wrong_isbn"
    t.string   "nbn"
    t.string   "lccn"
    t.string   "oclc_number"
    t.string   "issn"
    t.integer  "price"
    t.text     "fulltext"
    t.string   "volume_number_string"
    t.string   "issue_number_string"
    t.string   "serial_number_string"
    t.integer  "edition"
    t.text     "note"
    t.integer  "produces_count",                  default: 0,     null: false
    t.integer  "exemplifies_count",               default: 0,     null: false
    t.integer  "embodies_count",                  default: 0,     null: false
    t.integer  "work_has_subjects_count",         default: 0,     null: false
    t.boolean  "repository_content",              default: false, null: false
    t.integer  "lock_version",                    default: 0,     null: false
    t.integer  "required_role_id",                default: 1,     null: false
    t.string   "state"
    t.integer  "required_score",                  default: 0,     null: false
    t.integer  "frequency_id",                    default: 1,     null: false
    t.boolean  "subscription_master",             default: false, null: false
    t.text     "title_alternative_transcription"
    t.text     "description"
    t.text     "abstract"
    t.datetime "available_at"
    t.datetime "valid_until"
    t.datetime "date_submitted"
    t.datetime "date_accepted"
    t.datetime "date_caputured"
    t.string   "pub_date"
    t.string   "edition_string"
    t.integer  "volume_number"
    t.integer  "issue_number"
    t.integer  "serial_number"
    t.string   "doi"
    t.text     "statement_of_responsibility"
  end

  add_index "manifestations", ["access_address"], name: "index_manifestations_on_access_address"
  add_index "manifestations", ["carrier_type_id"], name: "index_manifestations_on_carrier_type_id"
  add_index "manifestations", ["doi"], name: "index_manifestations_on_doi"
  add_index "manifestations", ["frequency_id"], name: "index_manifestations_on_frequency_id"
  add_index "manifestations", ["isbn"], name: "index_manifestations_on_isbn"
  add_index "manifestations", ["issn"], name: "index_manifestations_on_issn"
  add_index "manifestations", ["lccn"], name: "index_manifestations_on_lccn"
  add_index "manifestations", ["manifestation_identifier"], name: "index_manifestations_on_manifestation_identifier"
  add_index "manifestations", ["nbn"], name: "index_manifestations_on_nbn"
  add_index "manifestations", ["oclc_number"], name: "index_manifestations_on_oclc_number"
  add_index "manifestations", ["required_role_id"], name: "index_manifestations_on_required_role_id"
  add_index "manifestations", ["updated_at"], name: "index_manifestations_on_updated_at"

  create_table "message_requests", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "message_template_id"
    t.datetime "sent_at"
    t.datetime "deleted_at"
    t.text     "body"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_requests", ["state"], name: "index_message_requests_on_state"

  create_table "message_templates", force: true do |t|
    t.string   "status",                    null: false
    t.text     "title",                     null: false
    t.text     "body",                      null: false
    t.integer  "position"
    t.string   "locale",     default: "en"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_templates", ["status"], name: "index_message_templates_on_status", unique: true

  create_table "messages", force: true do |t|
    t.datetime "read_at"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.string   "subject",            null: false
    t.text     "body"
    t.integer  "message_request_id"
    t.string   "state"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lft"
    t.integer  "rgt"
  end

  add_index "messages", ["message_request_id"], name: "index_messages_on_message_request_id"
  add_index "messages", ["parent_id"], name: "index_messages_on_parent_id"
  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "owns", force: true do |t|
    t.integer  "agent_id",   null: false
    t.integer  "item_id",    null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owns", ["agent_id"], name: "index_owns_on_agent_id"
  add_index "owns", ["item_id"], name: "index_owns_on_item_id"

  create_table "picture_files", force: true do |t|
    t.integer  "picture_attachable_id"
    t.string   "picture_attachable_type"
    t.string   "content_type"
    t.text     "title"
    t.string   "thumbnail"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picture_files", ["picture_attachable_id", "picture_attachable_type"], name: "index_picture_files_on_picture_attachable_id_and_type"

  create_table "produce_types", force: true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produces", force: true do |t|
    t.integer  "agent_id",         null: false
    t.integer  "manifestation_id", null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produce_type_id"
  end

  add_index "produces", ["agent_id"], name: "index_produces_on_agent_id"
  add_index "produces", ["manifestation_id"], name: "index_produces_on_manifestation_id"

  create_table "realize_types", force: true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "realizes", force: true do |t|
    t.integer  "agent_id",        null: false
    t.integer  "expression_id",   null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "realize_type_id"
  end

  add_index "realizes", ["agent_id"], name: "index_realizes_on_agent_id"
  add_index "realizes", ["expression_id"], name: "index_realizes_on_expression_id"

  create_table "request_status_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_types", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reserve_stat_has_manifestations", force: true do |t|
    t.integer  "manifestation_reserve_stat_id", null: false
    t.integer  "manifestation_id",              null: false
    t.integer  "reserves_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reserve_stat_has_manifestations", ["manifestation_id"], name: "index_reserve_stat_has_manifestations_on_manifestation_id"
  add_index "reserve_stat_has_manifestations", ["manifestation_reserve_stat_id"], name: "index_reserve_stat_has_manifestations_on_m_reserve_stat_id"

  create_table "reserve_stat_has_users", force: true do |t|
    t.integer  "user_reserve_stat_id", null: false
    t.integer  "user_id",              null: false
    t.integer  "reserves_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reserve_stat_has_users", ["user_id"], name: "index_reserve_stat_has_users_on_user_id"
  add_index "reserve_stat_has_users", ["user_reserve_stat_id"], name: "index_reserve_stat_has_users_on_user_reserve_stat_id"

  create_table "reserves", force: true do |t|
    t.integer  "user_id",                                      null: false
    t.integer  "manifestation_id",                             null: false
    t.integer  "item_id"
    t.integer  "request_status_type_id",                       null: false
    t.datetime "checked_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "canceled_at"
    t.datetime "expired_at"
    t.datetime "deleted_at"
    t.string   "state"
    t.boolean  "expiration_notice_to_patron",  default: false
    t.boolean  "expiration_notice_to_library", default: false
    t.datetime "retained_at"
    t.datetime "postponed_at"
    t.integer  "lock_version",                 default: 0,     null: false
  end

  add_index "reserves", ["item_id"], name: "index_reserves_on_item_id"
  add_index "reserves", ["manifestation_id"], name: "index_reserves_on_manifestation_id"
  add_index "reserves", ["request_status_type_id"], name: "index_reserves_on_request_status_type_id"
  add_index "reserves", ["state"], name: "index_reserves_on_state"
  add_index "reserves", ["user_id"], name: "index_reserves_on_user_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series_has_manifestations", force: true do |t|
    t.integer  "series_statement_id"
    t.integer  "manifestation_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "series_has_manifestations", ["manifestation_id"], name: "index_series_has_manifestations_on_manifestation_id"
  add_index "series_has_manifestations", ["series_statement_id"], name: "index_series_has_manifestations_on_series_statement_id"

  create_table "series_statements", force: true do |t|
    t.text     "original_title"
    t.text     "numbering"
    t.text     "title_subseries"
    t.text     "numbering_subseries"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title_transcription"
    t.text     "title_alternative"
    t.string   "series_statement_identifier"
    t.string   "issn"
    t.boolean  "periodical"
    t.integer  "manifestation_id"
    t.text     "note"
    t.text     "title_subseries_transcription"
  end

  add_index "series_statements", ["manifestation_id"], name: "index_series_statements_on_manifestation_id"
  add_index "series_statements", ["series_statement_identifier"], name: "index_series_statements_on_series_statement_identifier"

  create_table "shelves", force: true do |t|
    t.string   "name",                     null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "library_id",   default: 1, null: false
    t.integer  "items_count",  default: 0, null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "shelves", ["library_id"], name: "index_shelves_on_library_id"

  create_table "use_restrictions", force: true do |t|
    t.string   "name",         null: false
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_checkout_stats", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "note"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "user_checkout_stats", ["state"], name: "index_user_checkout_stats_on_state"

  create_table "user_group_has_checkout_types", force: true do |t|
    t.integer  "user_group_id",                                   null: false
    t.integer  "checkout_type_id",                                null: false
    t.integer  "checkout_limit",                  default: 0,     null: false
    t.integer  "checkout_period",                 default: 0,     null: false
    t.integer  "checkout_renewal_limit",          default: 0,     null: false
    t.integer  "reservation_limit",               default: 0,     null: false
    t.integer  "reservation_expired_period",      default: 7,     null: false
    t.boolean  "set_due_date_before_closing_day", default: false, null: false
    t.datetime "fixed_due_date"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_checkout_count"
  end

  add_index "user_group_has_checkout_types", ["checkout_type_id"], name: "index_user_group_has_checkout_types_on_checkout_type_id"
  add_index "user_group_has_checkout_types", ["user_group_id"], name: "index_user_group_has_checkout_types_on_user_group_id"

  create_table "user_groups", force: true do |t|
    t.string   "name"
    t.text     "string"
    t.text     "display_name"
    t.text     "note"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "valid_period_for_new_user",        default: 0, null: false
    t.datetime "expired_at"
    t.integer  "number_of_day_to_notify_overdue",  default: 1, null: false
    t.integer  "number_of_day_to_notify_due_date", default: 7, null: false
    t.integer  "number_of_time_to_notify_overdue", default: 3, null: false
  end

  create_table "user_has_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reserve_stats", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "note"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "completed_at"
  end

  add_index "user_reserve_stats", ["state"], name: "index_user_reserve_stats_on_state"

  create_table "users", force: true do |t|
    t.integer  "user_group_id"
    t.integer  "required_role_id"
    t.string   "username"
    t.text     "note"
    t.string   "locale"
    t.string   "user_number"
    t.integer  "library_id"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "save_checkout_history",    default: false, null: false
    t.string   "checkout_icalendar_token"
  end

  add_index "users", ["checkout_icalendar_token"], name: "index_users_on_checkout_icalendar_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end

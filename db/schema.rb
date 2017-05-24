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

ActiveRecord::Schema.define(version: 20170523155020) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "event_list_id", limit: 4
    t.string   "title",         limit: 128
    t.text     "address",       limit: 65535
    t.string   "postal_code",   limit: 32
    t.string   "city",          limit: 128
    t.string   "country",       limit: 128
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "addresses", ["event_list_id"], name: "index_addresses_on_event_list_id", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "blog_post_categories", force: :cascade do |t|
    t.string   "name",       limit: 128
    t.string   "color",      limit: 128
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "blog_posts", force: :cascade do |t|
    t.integer  "blog_post_category_id", limit: 4
    t.string   "title",                 limit: 128
    t.text     "perex",                 limit: 65535
    t.text     "text",                  limit: 65535
    t.boolean  "is_published",          limit: 1
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "image_file_name",       limit: 255
    t.string   "image_content_type",    limit: 255
    t.integer  "image_file_size",       limit: 4
    t.datetime "image_updated_at"
  end

  add_index "blog_posts", ["blog_post_category_id"], name: "index_blog_posts_on_blog_post_category_id", using: :btree

  create_table "contact_in_lists", force: :cascade do |t|
    t.integer  "contact_id",      limit: 4
    t.integer  "contact_list_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "contact_in_lists", ["contact_id"], name: "index_contact_in_lists_on_contact_id", using: :btree
  add_index "contact_in_lists", ["contact_list_id"], name: "index_contact_in_lists_on_contact_list_id", using: :btree

  create_table "contact_lists", force: :cascade do |t|
    t.integer  "employee_id", limit: 4
    t.string   "title",       limit: 128
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "contact_lists", ["employee_id"], name: "index_contact_lists_on_employee_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "organization_id", limit: 4
    t.string   "name",            limit: 128
    t.string   "nickname",        limit: 128
    t.string   "mail",            limit: 128
    t.string   "phone",           limit: 128
    t.string   "other_contacts",  limit: 128
    t.string   "dept",            limit: 128
    t.text     "notes",           limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "surname",         limit: 128
  end

  add_index "contacts", ["organization_id"], name: "index_contacts_on_organization_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 128
    t.string   "flag_code",  limit: 32
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string   "etype",      limit: 255
    t.string   "name_sk",    limit: 255
    t.string   "name_en",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "employee_with_knowledges", force: :cascade do |t|
    t.integer  "employee_id",  limit: 4
    t.integer  "knowledge_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "employee_with_knowledges", ["employee_id"], name: "index_employee_with_knowledges_on_employee_id", using: :btree
  add_index "employee_with_knowledges", ["knowledge_id"], name: "index_employee_with_knowledges_on_knowledge_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "department", limit: 128
    t.string   "work_mail",  limit: 128
    t.string   "work_phone", limit: 128
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "event_categories", force: :cascade do |t|
    t.string   "name",       limit: 128
    t.string   "abbr",       limit: 32
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "event_category_alliances", force: :cascade do |t|
    t.integer  "event_category_id", limit: 4
    t.string   "name",              limit: 128
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "event_category_alliances", ["event_category_id"], name: "index_event_category_alliances_on_event_category_id", using: :btree

  create_table "event_category_scis", force: :cascade do |t|
    t.integer  "event_category_id", limit: 4
    t.string   "name",              limit: 128
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "event_category_scis", ["event_category_id"], name: "index_event_category_scis_on_event_category_id", using: :btree

  create_table "event_column_sets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_columns", force: :cascade do |t|
    t.integer  "event_column_set_id", limit: 4
    t.string   "my",                  limit: 255
    t.string   "their",               limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "event_columns", ["event_column_set_id"], name: "index_event_columns_on_event_column_set_id", using: :btree

  create_table "event_documents", force: :cascade do |t|
    t.integer  "event_id",     limit: 4
    t.string   "title",        limit: 128
    t.boolean  "is_mandatory", limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "event_documents", ["event_id"], name: "index_event_documents_on_event_id", using: :btree

  create_table "event_in_lists", force: :cascade do |t|
    t.integer  "event_id",      limit: 4
    t.integer  "event_list_id", limit: 4
    t.string   "state",         limit: 128
    t.integer  "priority",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "event_in_lists", ["event_id"], name: "index_event_in_lists_on_event_id", using: :btree
  add_index "event_in_lists", ["event_list_id"], name: "index_event_in_lists_on_event_list_id", using: :btree

  create_table "event_lists", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "education_id",    limit: 4
    t.boolean  "is_child",        limit: 1
    t.string   "state",           limit: 128,   default: "opened"
    t.string   "name",            limit: 128
    t.string   "surname",         limit: 128
    t.date     "birth_date"
    t.string   "place_of_birth",  limit: 128
    t.string   "nationality",     limit: 128
    t.string   "occupation",      limit: 128
    t.string   "sex",             limit: 32
    t.string   "personal_mail",   limit: 128
    t.string   "personal_phone",  limit: 128
    t.string   "emergency_phone", limit: 128
    t.string   "emergency_name",  limit: 128
    t.string   "emergency_mail",  limit: 128
    t.text     "experiences",     limit: 65535
    t.text     "why",             limit: 65535
    t.text     "remarks",         limit: 65535
    t.text     "on_health",       limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "event_lists", ["education_id"], name: "index_event_lists_on_education_id", using: :btree
  add_index "event_lists", ["user_id"], name: "index_event_lists_on_user_id", using: :btree

  create_table "event_row_associations", force: :cascade do |t|
    t.string   "my",         limit: 256
    t.string   "their_1",    limit: 256
    t.string   "their_2",    limit: 256
    t.string   "their_3",    limit: 256
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "event_table_columns", force: :cascade do |t|
    t.integer  "event_table_row_id", limit: 4
    t.string   "name",               limit: 128
    t.string   "color",              limit: 128
    t.text     "value",              limit: 65535
    t.string   "ctype",              limit: 128
    t.integer  "priority",           limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "event_table_columns", ["event_table_row_id"], name: "index_event_table_columns_on_event_table_row_id", using: :btree

  create_table "event_table_rows", force: :cascade do |t|
    t.integer  "event_table_id", limit: 4
    t.boolean  "is_header",      limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "event_table_rows", ["event_table_id"], name: "index_event_table_rows_on_event_table_id", using: :btree

  create_table "event_tables", force: :cascade do |t|
    t.integer  "event_type_id", limit: 4
    t.string   "name",          limit: 128
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "event_tables", ["event_type_id"], name: "index_event_tables_on_event_type_id", using: :btree

  create_table "event_types", force: :cascade do |t|
    t.integer  "super_event_type_id",                   limit: 4
    t.string   "title",                                 limit: 128
    t.integer  "employee_id",                           limit: 4
    t.boolean  "can_send_registration_mail",            limit: 1
    t.float    "fee_member_first",                      limit: 24
    t.float    "fee_non_member_first",                  limit: 24
    t.float    "fee_member_other",                      limit: 24
    t.float    "fee_non_member_other",                  limit: 24
    t.text     "fee_description",                       limit: 65535
    t.text     "application_conditions_html",           limit: 65535
    t.text     "application_conditions_agreement_html", limit: 65535
    t.text     "application_info_html",                 limit: 65535
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "event_types", ["employee_id"], name: "index_event_types_on_employee_id", using: :btree
  add_index "event_types", ["super_event_type_id"], name: "index_event_types_on_super_event_type_id", using: :btree

  create_table "event_with_categories", force: :cascade do |t|
    t.integer  "event_category_id", limit: 4
    t.integer  "event_id",          limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "event_with_categories", ["event_category_id"], name: "index_event_with_categories_on_event_category_id", using: :btree
  add_index "event_with_categories", ["event_id"], name: "index_event_with_categories_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "organization_id",                   limit: 4
    t.integer  "event_type_id",                     limit: 4
    t.string   "title",                             limit: 512
    t.string   "title_en",                          limit: 512
    t.datetime "from"
    t.datetime "to"
    t.boolean  "is_only_date",                      limit: 1
    t.string   "code",                              limit: 256
    t.string   "code_alliance",                     limit: 256
    t.string   "country",                           limit: 64
    t.string   "city",                              limit: 2048
    t.text     "address",                           limit: 65535
    t.string   "gps_latitude",                      limit: 32
    t.string   "gps_longitude",                     limit: 32
    t.text     "notes",                             limit: 65535
    t.string   "airport",                           limit: 2048
    t.string   "bus_train",                         limit: 2048
    t.integer  "capacity_men",                      limit: 4,     default: 0
    t.integer  "capacity_women",                    limit: 4,     default: 0
    t.integer  "capacity_total",                    limit: 4,     default: 0
    t.integer  "free_men",                          limit: 4,     default: 0
    t.integer  "free_women",                        limit: 4,     default: 0
    t.integer  "free_total",                        limit: 4,     default: 0
    t.integer  "min_age",                           limit: 4,     default: 0
    t.integer  "max_age",                           limit: 4,     default: 100
    t.text     "fees_sk",                           limit: 65535
    t.text     "fees_en",                           limit: 65535
    t.datetime "registration_deadline"
    t.boolean  "is_simple_registration",            limit: 1
    t.boolean  "can_create_member_registration",    limit: 1
    t.string   "evaluation_url_leader",             limit: 256
    t.datetime "evaluation_deadline_leader"
    t.string   "evaluation_url_local_partner",      limit: 256
    t.datetime "evaluation_deadline_local_partner"
    t.string   "evaluation_url_volunteer",          limit: 256
    t.datetime "evaluation_deadline_volunteer"
    t.boolean  "is_published",                      limit: 1,     default: false
    t.text     "introduction_sk",                   limit: 65535
    t.text     "type_of_work_sk",                   limit: 65535
    t.text     "study_theme_sk",                    limit: 65535
    t.text     "accomodation_sk",                   limit: 65535
    t.text     "camp_advert_sk",                    limit: 65535
    t.text     "language_description_sk",           limit: 65535
    t.text     "requirements_sk",                   limit: 65535
    t.text     "location_sk",                       limit: 65535
    t.text     "additional_camp_notes_sk",          limit: 65535
    t.text     "introduction_en",                   limit: 65535
    t.text     "type_of_work_en",                   limit: 65535
    t.text     "study_theme_en",                    limit: 65535
    t.text     "accomodation_en",                   limit: 65535
    t.text     "camp_advert_en",                    limit: 65535
    t.text     "language_description_en",           limit: 65535
    t.text     "requirements_en",                   limit: 65535
    t.text     "location_en",                       limit: 65535
    t.text     "additional_camp_notes_en",          limit: 65535
    t.string   "required_spoken_language",          limit: 256
    t.boolean  "is_cancelled",                      limit: 1,     default: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.boolean  "ignore_sex_for_capacity",           limit: 1
  end

  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
  add_index "events", ["organization_id"], name: "index_events_on_organization_id", using: :btree

  create_table "extra_fees", force: :cascade do |t|
    t.integer  "event_id",        limit: 4
    t.float    "amount",          limit: 24
    t.string   "name",            limit: 128
    t.string   "currency",        limit: 32
    t.boolean  "is_paid_to_inex", limit: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "extra_fees", ["event_id"], name: "index_extra_fees_on_event_id", using: :btree

  create_table "homepage_cards", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "url",                  limit: 255
    t.integer  "priority",             limit: 4
    t.boolean  "is_visible",           limit: 1
    t.string   "image_1_file_name",    limit: 255
    t.string   "image_1_content_type", limit: 255
    t.integer  "image_1_file_size",    limit: 4
    t.datetime "image_1_updated_at"
    t.string   "image_2_file_name",    limit: 255
    t.string   "image_2_content_type", limit: 255
    t.integer  "image_2_file_size",    limit: 4
    t.datetime "image_2_updated_at"
    t.string   "image_3_file_name",    limit: 255
    t.string   "image_3_content_type", limit: 255
    t.integer  "image_3_file_size",    limit: 4
    t.datetime "image_3_updated_at"
    t.string   "image_4_file_name",    limit: 255
    t.string   "image_4_content_type", limit: 255
    t.integer  "image_4_file_size",    limit: 4
    t.datetime "image_4_updated_at"
    t.string   "image_5_file_name",    limit: 255
    t.string   "image_5_content_type", limit: 255
    t.integer  "image_5_file_size",    limit: 4
    t.datetime "image_5_updated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "homepage_partners", force: :cascade do |t|
    t.string   "img_url",            limit: 128
    t.text     "text",               limit: 65535
    t.string   "url",                limit: 256
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "html_articles", force: :cascade do |t|
    t.string   "category",   limit: 128
    t.string   "title",      limit: 128
    t.text     "content",    limit: 16777215
    t.string   "url",        limit: 256
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "import_workcamps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_tickets", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.text     "description",        limit: 65535
    t.integer  "priority",           limit: 4
    t.boolean  "is_done",            limit: 1
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "issue_tickets", ["user_id"], name: "index_issue_tickets_on_user_id", using: :btree

  create_table "knowledge_categories", force: :cascade do |t|
    t.string   "category",   limit: 128
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "knowledge_in_categories", force: :cascade do |t|
    t.integer  "knowledge_id",          limit: 4
    t.integer  "knowledge_category_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "knowledge_in_categories", ["knowledge_category_id"], name: "index_knowledge_in_categories_on_knowledge_category_id", using: :btree
  add_index "knowledge_in_categories", ["knowledge_id"], name: "index_knowledge_in_categories_on_knowledge_id", using: :btree

  create_table "knowledges", force: :cascade do |t|
    t.string   "title",      limit: 128
    t.text     "text",       limit: 65535
    t.string   "keywords",   limit: 128
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "language_skills", force: :cascade do |t|
    t.integer  "language_id",   limit: 4
    t.integer  "event_list_id", limit: 4
    t.string   "level",         limit: 128
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "language_skills", ["event_list_id"], name: "index_language_skills_on_event_list_id", using: :btree
  add_index "language_skills", ["language_id"], name: "index_language_skills_on_language_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 128
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "leaders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "leaders", ["event_id"], name: "index_leaders_on_event_id", using: :btree
  add_index "leaders", ["user_id"], name: "index_leaders_on_user_id", using: :btree

  create_table "local_partners", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "local_partners", ["event_id"], name: "index_local_partners_on_event_id", using: :btree
  add_index "local_partners", ["user_id"], name: "index_local_partners_on_user_id", using: :btree

  create_table "log_activities", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "action",     limit: 255
    t.string   "what",       limit: 4096
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "log_activities", ["user_id"], name: "index_log_activities_on_user_id", using: :btree

  create_table "mercury_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_in_networks", force: :cascade do |t|
    t.integer  "organization_id",    limit: 4
    t.integer  "partner_network_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "organization_in_networks", ["organization_id"], name: "index_organization_in_networks_on_organization_id", using: :btree
  add_index "organization_in_networks", ["partner_network_id"], name: "index_organization_in_networks_on_partner_network_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",               limit: 64
    t.text     "description",        limit: 65535
    t.string   "country",            limit: 128
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "participation_fees", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "event_list_id", limit: 4
    t.float    "amount",        limit: 24
    t.date     "date"
    t.text     "notes",         limit: 65535
    t.string   "pay_type",      limit: 128
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "participation_fees", ["event_list_id"], name: "index_participation_fees_on_event_list_id", using: :btree
  add_index "participation_fees", ["user_id"], name: "index_participation_fees_on_user_id", using: :btree

  create_table "partner_networks", force: :cascade do |t|
    t.string   "name",        limit: 64
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "role",       limit: 255
    t.string   "controller", limit: 255
    t.string   "action",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "recommendation_results", force: :cascade do |t|
    t.integer  "recommender_id", limit: 4
    t.string   "title",          limit: 1024
    t.string   "thumbnail_url",  limit: 1024
    t.string   "url",            limit: 1024
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "recommendation_results", ["recommender_id"], name: "index_recommendation_results_on_recommender_id", using: :btree

  create_table "recommenders", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "html_article_id", limit: 4
    t.integer  "blog_post_id",    limit: 4
  end

  add_index "recommenders", ["blog_post_id"], name: "index_recommenders_on_blog_post_id", using: :btree
  add_index "recommenders", ["html_article_id"], name: "index_recommenders_on_html_article_id", using: :btree

  create_table "super_event_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "task_lists", force: :cascade do |t|
    t.integer  "task_id",     limit: 4
    t.string   "title",       limit: 128
    t.text     "description", limit: 65535
    t.string   "state",       limit: 128
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "task_lists", ["task_id"], name: "index_task_lists_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "employee_id",    limit: 4
    t.string   "title",          limit: 128
    t.text     "description",    limit: 65535
    t.boolean  "is_repeatable",  limit: 1
    t.boolean  "is_highlighted", limit: 1
    t.date     "deadline"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "tasks", ["employee_id"], name: "index_tasks_on_employee_id", using: :btree

  create_table "trainers", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "trainers", ["event_id"], name: "index_trainers_on_event_id", using: :btree
  add_index "trainers", ["user_id"], name: "index_trainers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "employee_id",     limit: 4
    t.integer  "education_id",    limit: 4
    t.string   "login_mail",      limit: 128
    t.string   "password_digest", limit: 128
    t.string   "state",           limit: 128,   default: "active"
    t.string   "role",            limit: 128
    t.string   "name",            limit: 128
    t.string   "surname",         limit: 128
    t.date     "birth_date"
    t.string   "place_of_birth",  limit: 128
    t.string   "nationality",     limit: 128
    t.string   "occupation",      limit: 128
    t.string   "nickname",        limit: 128
    t.string   "sex",             limit: 32,    default: "M"
    t.string   "personal_mail",   limit: 128
    t.string   "personal_phone",  limit: 128
    t.text     "other_contacts",  limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "users", ["education_id"], name: "index_users_on_education_id", using: :btree
  add_index "users", ["employee_id"], name: "index_users_on_employee_id", using: :btree

  create_table "volunteers", force: :cascade do |t|
    t.integer  "event_id",      limit: 4
    t.integer  "event_list_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "volunteers", ["event_id"], name: "index_volunteers_on_event_id", using: :btree
  add_index "volunteers", ["event_list_id"], name: "index_volunteers_on_event_list_id", using: :btree

  add_foreign_key "recommenders", "blog_posts"
  add_foreign_key "recommenders", "html_articles"
end

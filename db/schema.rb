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

ActiveRecord::Schema.define(version: 20170124165952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "users", force: true do |t|
    t.text     "email"
    t.text     "name"
    t.text     "nickname"
    t.text     "bio"
    t.text     "image_url"
    t.boolean  "newsletter",                         default: false
    t.boolean  "project_updates",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.text     "full_name"
    t.text     "address_street"
    t.text     "address_number"
    t.text     "address_complement"
    t.text     "address_neighborhood"
    t.text     "address_city"
    t.text     "address_state"
    t.text     "address_zip_code"
    t.text     "phone_number"
    t.text     "locale",                             default: "pt",  null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "other_url"
    t.text     "uploaded_image"
    t.string   "state_inscription"
    t.string   "profile_type"
    t.string   "linkedin_url"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "new_project",                        default: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "completeness_progress",              default: 0
    t.date     "birthday"
    t.string   "nationality"
    t.string   "residence_country"
    t.boolean  "nonprofitauth"
    t.index ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    t.index ["email"], :name => "index_users_on_email"
    t.index ["latitude", "longitude"], :name => "index_users_on_latitude_and_longitude"
    t.index ["name"], :name => "index_users_on_name"
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  create_table "api_access_tokens", force: true do |t|
    t.string   "code",                       null: false
    t.boolean  "expired",    default: false, null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["expired"], :name => "index_api_access_tokens_on_expired"
    t.index ["user_id"], :name => "index_api_access_tokens_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_api_access_tokens_user_id"
  end

  create_table "oauth_providers", force: true do |t|
    t.text     "name",       null: false
    t.text     "key",        null: false
    t.text     "secret",     null: false
    t.text     "scope"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "strategy"
    t.text     "path"
    t.index ["name"], :name => "oauth_providers_name_unique", :unique => true
  end

  create_table "authorizations", force: true do |t|
    t.integer  "oauth_provider_id",       null: false
    t.integer  "user_id",                 null: false
    t.text     "uid",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "access_token_expires_at"
    t.index ["oauth_provider_id", "user_id"], :name => "index_authorizations_on_oauth_provider_id_and_user_id", :unique => true
    t.index ["oauth_provider_id"], :name => "fk__authorizations_oauth_provider_id"
    t.index ["uid", "oauth_provider_id"], :name => "index_authorizations_on_uid_and_oauth_provider_id", :unique => true
    t.index ["user_id"], :name => "fk__authorizations_user_id"
    t.foreign_key ["oauth_provider_id"], "oauth_providers", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_authorizations_oauth_provider_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_authorizations_user_id"
  end

  create_table "balanced_contributors", force: true do |t|
    t.integer  "user_id"
    t.string   "href"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bank_account_href"
    t.index ["user_id"], :name => "index_balanced_contributors_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_balanced_contributors_user_id"
  end

  create_table "bank_informations", force: true do |t|
    t.integer "user_id", null: false
    t.string  "iban"
    t.string  "bic"
    t.string  "key"
    t.index ["user_id"], :name => "index_bank_informations_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_bank_informations_user_id"
  end

  create_table "blogo_posts", force: true do |t|
    t.integer  "user_id",          null: false
    t.string   "permalink",        null: false
    t.string   "title",            null: false
    t.boolean  "published",        null: false
    t.datetime "published_at",     null: false
    t.string   "markup_lang",      null: false
    t.text     "raw_content",      null: false
    t.text     "html_content",     null: false
    t.text     "html_overview"
    t.string   "tags_string"
    t.string   "meta_description", null: false
    t.string   "meta_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["permalink"], :name => "index_blogo_posts_on_permalink", :unique => true
    t.index ["published_at"], :name => "index_blogo_posts_on_published_at"
    t.index ["user_id"], :name => "fk__blogo_posts_user_id"
    t.index ["user_id"], :name => "index_blogo_posts_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_blogo_posts_user_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",    default: false
  end

  create_table "blogo_taggings", force: true do |t|
    t.integer "blogo_post_id", null: false
    t.integer "tag_id",        null: false
    t.index ["blogo_post_id"], :name => "fk__blogo_taggings_blogo_post_id"
    t.index ["tag_id", "blogo_post_id"], :name => "index_blogo_taggings_on_tag_id_and_blogo_post_id", :unique => true
    t.index ["tag_id"], :name => "fk__blogo_taggings_tag_id"
    t.foreign_key ["blogo_post_id"], "blogo_posts", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_blogo_taggings_blogo_post_id"
    t.foreign_key ["tag_id"], "tags", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_blogo_taggings_tag_id"
  end

  create_table "blogo_tags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], :name => "index_blogo_tags_on_name", :unique => true
  end

  create_table "blogo_users", force: true do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], :name => "index_blogo_users_on_email", :unique => true
  end

  create_table "categories", force: true do |t|
    t.text     "name_pt",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_en"
    t.string   "name_fr"
    t.index ["name_pt"], :name => "categories_name_unique", :unique => true
    t.index ["name_pt"], :name => "index_categories_on_name_pt"
  end

  create_table "channels", force: true do |t|
    t.text     "name",                                            null: false
    t.text     "description",                                     null: false
    t.text     "permalink",                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image"
    t.text     "video_url"
    t.string   "video_embed_url"
    t.text     "how_it_works"
    t.text     "how_it_works_html"
    t.string   "terms_url"
    t.text     "state",                         default: "draft"
    t.integer  "user_id"
    t.boolean  "accepts_projects",              default: true
    t.text     "submit_your_project_text"
    t.text     "submit_your_project_text_html"
    t.hstore   "start_content"
    t.string   "start_hero_image"
    t.hstore   "success_content"
    t.string   "application_url"
    t.index ["permalink"], :name => "index_channels_on_permalink", :unique => true
    t.index ["user_id"], :name => "fk__channels_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_channels_user_id"
  end

  create_table "channel_members", force: true do |t|
    t.integer  "channel_id"
    t.integer  "user_id"
    t.boolean  "admin",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id"], :name => "index_channel_members_on_channel_id"
    t.index ["user_id"], :name => "index_channel_members_on_user_id"
    t.foreign_key ["channel_id"], "channels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_channel_members_channel_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_channel_members_user_id"
  end

  create_table "projects", force: true do |t|
    t.text     "name",                                 null: false
    t.integer  "user_id",                              null: false
    t.integer  "category_id",                          null: false
    t.decimal  "goal",                                 null: false
    t.text     "about",                                null: false
    t.text     "headline",                             null: false
    t.text     "video_url"
    t.text     "short_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about_html"
    t.boolean  "recommended",          default: false
    t.text     "home_page_comment"
    t.text     "permalink",                            null: false
    t.text     "video_thumbnail"
    t.string   "state"
    t.integer  "online_days",          default: 0
    t.datetime "online_date"
    t.text     "how_know"
    t.text     "more_urls"
    t.text     "first_contributions"
    t.string   "uploaded_image"
    t.string   "video_embed_url"
    t.text     "budget"
    t.text     "budget_html"
    t.text     "terms"
    t.text     "terms_html"
    t.string   "site"
    t.string   "hash_tag"
    t.string   "address_city"
    t.string   "address_state"
    t.string   "address_zip_code"
    t.string   "address_neighborhood"
    t.boolean  "foundation_widget",    default: false
    t.text     "campaign_type"
    t.boolean  "featured",             default: false
    t.boolean  "home_page"
    t.text     "about_textile"
    t.text     "budget_textile"
    t.text     "terms_textile"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "referral_url"
    t.string   "hero_image"
    t.datetime "sent_to_analysis_at"
    t.string   "organization_type"
    t.string   "street_address"
    t.string   "currency",             default: "EUR", null: false
    t.index ["category_id"], :name => "index_projects_on_category_id"
    t.index ["latitude", "longitude"], :name => "index_projects_on_latitude_and_longitude"
    t.index ["name"], :name => "index_projects_on_name"
    t.index ["permalink"], :name => "index_projects_on_permalink", :unique => true
    t.index ["user_id"], :name => "index_projects_on_user_id"
    t.foreign_key ["category_id"], "categories", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "projects_category_id_reference"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "projects_user_id_reference"
  end

  create_table "channels_projects", force: true do |t|
    t.integer "channel_id"
    t.integer "project_id"
    t.index ["channel_id", "project_id"], :name => "index_channels_projects_on_channel_id_and_project_id", :unique => true
    t.index ["project_id"], :name => "index_channels_projects_on_project_id"
    t.foreign_key ["channel_id"], "channels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_channels_projects_channel_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_channels_projects_project_id"
  end

  create_table "channels_subscribers", force: true do |t|
    t.integer "user_id",    null: false
    t.integer "channel_id", null: false
    t.index ["channel_id"], :name => "fk__channels_subscribers_channel_id"
    t.index ["user_id", "channel_id"], :name => "index_channels_subscribers_on_user_id_and_channel_id", :unique => true
    t.index ["user_id"], :name => "fk__channels_subscribers_user_id"
    t.foreign_key ["channel_id"], "channels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_channels_subscribers_channel_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_channels_subscribers_user_id"
  end

  create_table "contacts", force: true do |t|
    t.string   "first_name",           null: false
    t.string   "last_name",            null: false
    t.string   "email",                null: false
    t.string   "phone"
    t.string   "organization_name",    null: false
    t.string   "organization_website"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "project_id",                                       null: false
    t.integer  "user_id"
    t.date     "starts_at",                                        null: false
    t.date     "finishes_at",                                      null: false
    t.decimal  "value_unit",                                       null: false
    t.decimal  "value"
    t.boolean  "completed",                        default: false, null: false
    t.string   "payment_id"
    t.text     "payment_choice"
    t.text     "payment_method"
    t.text     "payment_token"
    t.decimal  "payment_service_fee",              default: 0.0
    t.boolean  "payment_service_fee_paid_by_user", default: true
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
    t.datetime "confirmed_at"
    t.index ["project_id"], :name => "index_matches_on_project_id"
    t.index ["user_id"], :name => "index_matches_on_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_matches_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_matches_user_id"
  end

  create_table "matchings", force: true do |t|
    t.integer  "match_id"
    t.integer  "contribution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["contribution_id"], :name => "index_matchings_on_contribution_id"
    t.index ["match_id"], :name => "index_matchings_on_match_id"
    t.foreign_key ["match_id"], "matches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_matchings_match_id"
  end

  create_table "rewards", force: true do |t|
    t.integer  "project_id",                            null: false
    t.decimal  "minimum_value",                         null: false
    t.integer  "maximum_contributions"
    t.text     "description",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reindex_versions"
    t.integer  "row_order"
    t.integer  "days_to_delivery"
    t.boolean  "soon",                  default: false
    t.string   "title",                 default: "",    null: false
    t.index ["project_id"], :name => "index_rewards_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "rewards_project_id_reference"
  end

  create_table "contributions", force: true do |t|
    t.integer  "project_id",                                       null: false
    t.integer  "user_id",                                          null: false
    t.integer  "reward_id"
    t.decimal  "value",                                            null: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "anonymous",                        default: false
    t.text     "key"
    t.boolean  "credits",                          default: false
    t.boolean  "notified_finish",                  default: false
    t.text     "payment_method"
    t.text     "payment_token"
    t.string   "payment_id"
    t.text     "payer_name"
    t.text     "payer_email"
    t.text     "payer_document"
    t.text     "address_street"
    t.text     "address_number"
    t.text     "address_complement"
    t.text     "address_neighborhood"
    t.text     "address_zip_code"
    t.text     "address_city"
    t.text     "address_state"
    t.text     "address_phone_number"
    t.text     "payment_choice"
    t.decimal  "payment_service_fee",              default: 0.0,   null: false
    t.string   "state"
    t.text     "short_note"
    t.text     "referral_url"
    t.boolean  "payment_service_fee_paid_by_user", default: false
    t.integer  "matching_id"
    t.string   "currency"
    t.decimal  "value_in_euros"
    t.decimal  "value_in_rwf"
    t.index ["key"], :name => "index_contributions_on_key"
    t.index ["matching_id"], :name => "index_contributions_on_matching_id"
    t.index ["project_id"], :name => "index_contributions_on_project_id"
    t.index ["reward_id"], :name => "index_contributions_on_reward_id"
    t.index ["user_id"], :name => "index_contributions_on_user_id"
    t.foreign_key ["matching_id"], "matchings", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_contributions_matching_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "contributions_project_id_reference"
    t.foreign_key ["reward_id"], "rewards", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "contributions_reward_id_reference"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "contributions_user_id_reference"
  end

  add_foreign_key "matchings", ["contribution_id"], "contributions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_matchings_contribution_id"

  create_view "funding_raised_per_project_reports", " SELECT project.id AS project_id,\n    project.name AS project_name,\n    sum(backers.value) AS total_raised,\n    count(*) AS total_backs,\n    count(DISTINCT backers.user_id) AS total_backers\n   FROM (contributions backers\n     JOIN projects project ON ((project.id = backers.project_id)))\n  WHERE ((backers.state)::text <> ALL (ARRAY[('waiting_confirmation'::character varying)::text, ('pending'::character varying)::text, ('canceled'::character varying)::text, 'deleted'::text]))\n  GROUP BY project.id", :force => true
  create_table "images", force: true do |t|
    t.string   "file",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "index_images_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_images_user_id"
  end

  create_table "investment_prospects", force: true do |t|
    t.integer  "user_id"
    t.float    "value",      default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "index_investment_prospects_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_investment_prospects_user_id"
  end

  create_table "kyc_files", force: true do |t|
    t.integer  "user_id",        null: false
    t.string   "uploaded_image"
    t.string   "proof_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_key"
    t.index ["user_id"], :name => "index_kyc_files_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_kyc_files_user_id"
  end

  create_table "mangopay_contributors", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "key",                                  null: false
    t.string   "href"
    t.string   "wallet_key"
    t.string   "verification_level", default: "light"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["organization_id"], :name => "fk__mangopay_contributors_organization_id"
    t.index ["user_id"], :name => "index_mangopay_contributors_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_mangopay_contributors_user_id"
  end

  create_table "mangopay_registered_cards", force: true do |t|
    t.integer "user_id",                  null: false
    t.string  "currency", default: "EUR", null: false
    t.string  "key",                      null: false
    t.index ["user_id"], :name => "index_mangopay_registered_cards_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_mangopay_registered_cards_user_id"
  end

  create_table "mangopay_wallet_handlers", force: true do |t|
    t.integer  "project_id"
    t.string   "wallet_key", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_mangopay_wallet_handlers_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_mangopay_wallet_handlers_project_id"
  end

  create_view "neighborly_admin_funding_raised_per_project_reports", " SELECT project.id AS project_id,\n    project.name AS project_name,\n    sum(contributions.value) AS total_raised,\n    count(*) AS total_backs,\n    count(DISTINCT contributions.user_id) AS total_backers\n   FROM (contributions\n     JOIN projects project ON ((project.id = contributions.project_id)))\n  WHERE ((contributions.state)::text <> ALL (ARRAY[('waiting_confirmation'::character varying)::text, ('pending'::character varying)::text, ('canceled'::character varying)::text, 'deleted'::text]))\n  GROUP BY project.id", :force => true
  create_view "neighborly_admin_statistics", " SELECT ( SELECT count(*) AS count\n           FROM users) AS total_users,\n    ( SELECT count(*) AS count\n           FROM users\n          WHERE ((users.profile_type)::text = 'organization'::text)) AS total_organization_users,\n    ( SELECT count(*) AS count\n           FROM users\n          WHERE ((users.profile_type)::text = 'personal'::text)) AS total_personal_users,\n    ( SELECT count(*) AS count\n           FROM users\n          WHERE ((users.profile_type)::text = 'channel'::text)) AS total_channel_users,\n    ( SELECT count(*) AS count\n           FROM ( SELECT DISTINCT projects.address_city,\n                    projects.address_state\n                   FROM projects) count) AS total_communities,\n    contributions_totals.total_contributions,\n    contributions_totals.total_contributors,\n    contributions_totals.total_contributed,\n    projects_totals.total_projects,\n    projects_totals.total_projects_success,\n    projects_totals.total_projects_online,\n    projects_totals.total_projects_draft,\n    projects_totals.total_projects_soon\n   FROM ( SELECT count(*) AS total_contributions,\n            count(DISTINCT contributions.user_id) AS total_contributors,\n            sum(contributions.value) AS total_contributed\n           FROM contributions\n          WHERE ((contributions.state)::text <> ALL (ARRAY[('waiting_confirmation'::character varying)::text, ('pending'::character varying)::text, ('canceled'::character varying)::text, 'deleted'::text]))) contributions_totals,\n    ( SELECT count(*) AS total_projects,\n            count(\n                CASE\n                    WHEN ((projects.state)::text = 'draft'::text) THEN 1\n                    ELSE NULL::integer\n                END) AS total_projects_draft,\n            count(\n                CASE\n                    WHEN ((projects.state)::text = 'soon'::text) THEN 1\n                    ELSE NULL::integer\n                END) AS total_projects_soon,\n            count(\n                CASE\n                    WHEN ((projects.state)::text = 'successful'::text) THEN 1\n                    ELSE NULL::integer\n                END) AS total_projects_success,\n            count(\n                CASE\n                    WHEN ((projects.state)::text = 'online'::text) THEN 1\n                    ELSE NULL::integer\n                END) AS total_projects_online\n           FROM projects\n          WHERE ((projects.state)::text <> ALL (ARRAY[('deleted'::character varying)::text, ('rejected'::character varying)::text]))) projects_totals", :force => true
  create_table "neighborly_balanced_orders", force: true do |t|
    t.integer  "project_id", null: false
    t.string   "href",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_neighborly_balanced_orders_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_neighborly_balanced_orders_project_id"
  end

  create_table "neighborly_mangopay_orders", force: true do |t|
    t.integer  "project_id",      null: false
    t.integer  "contribution_id", null: false
    t.integer  "user_id",         null: false
    t.string   "order_key",       null: false
    t.string   "refund_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["contribution_id"], :name => "index_neighborly_mangopay_orders_on_contribution_id"
    t.index ["project_id"], :name => "index_neighborly_mangopay_orders_on_project_id"
    t.index ["user_id"], :name => "index_neighborly_mangopay_orders_on_user_id"
    t.foreign_key ["contribution_id"], "contributions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_neighborly_mangopay_orders_contribution_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_neighborly_mangopay_orders_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_neighborly_mangopay_orders_user_id"
  end

  create_table "updates", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "project_id",                      null: false
    t.text     "title"
    t.text     "comment",                         null: false
    t.text     "comment_html",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exclusive",       default: false
    t.text     "comment_textile"
    t.index ["project_id"], :name => "index_updates_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "updates_project_id_fk"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "updates_user_id_fk"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "project_id"
    t.boolean  "dismissed",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contribution_id"
    t.integer  "update_id"
    t.text     "origin_email",                    null: false
    t.text     "origin_name",                     null: false
    t.text     "template_name",                   null: false
    t.text     "locale",                          null: false
    t.integer  "channel_id"
    t.integer  "contact_id"
    t.string   "bcc"
    t.integer  "match_id"
    t.index ["channel_id"], :name => "fk__notifications_channel_id"
    t.index ["contact_id"], :name => "fk__notifications_company_contact_id"
    t.index ["match_id"], :name => "index_notifications_on_match_id"
    t.index ["update_id"], :name => "index_notifications_on_update_id"
    t.foreign_key ["channel_id"], "channels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_notifications_channel_id"
    t.foreign_key ["contact_id"], "contacts", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_notifications_company_contact_id"
    t.foreign_key ["contribution_id"], "contributions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "notifications_backer_id_fk"
    t.foreign_key ["match_id"], "matches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_notifications_match_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "notifications_project_id_reference"
    t.foreign_key ["update_id"], "updates", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "notifications_update_id_fk"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "notifications_user_id_reference"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "index_organizations_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_organizations_user_id"
  end

  create_table "payment_notifications", force: true do |t|
    t.integer  "contribution_id", null: false
    t.text     "extra_data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "match_id"
    t.index ["contribution_id"], :name => "index_payment_notifications_on_contribution_id"
    t.index ["match_id"], :name => "index_payment_notifications_on_match_id"
    t.foreign_key ["contribution_id"], "contributions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "payment_notifications_backer_id_fk"
    t.foreign_key ["match_id"], "matches", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_payment_notifications_match_id"
  end

  create_table "payouts", force: true do |t|
    t.string   "payment_service"
    t.integer  "project_id",                      null: false
    t.integer  "user_id"
    t.decimal  "value",                           null: false
    t.boolean  "manual",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_payouts_on_project_id"
    t.index ["user_id"], :name => "index_payouts_on_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_payouts_project_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_payouts_user_id"
  end

  create_table "press_assets", force: true do |t|
    t.string   "title"
    t.text     "image"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_documents", force: true do |t|
    t.text     "document"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.index ["project_id"], :name => "index_project_documents_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_documents_project_id"
  end

  create_table "project_faqs", force: true do |t|
    t.text     "answer"
    t.text     "title"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_project_faqs_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_faqs_project_id"
  end

  create_table "project_totals", force: true do |t|
    t.integer  "project_id"
    t.decimal  "net_amount",                          default: 0.0
    t.decimal  "platform_fee",                        default: 0.0
    t.decimal  "pledged",                             default: 0.0
    t.integer  "progress",                            default: 0
    t.integer  "total_contributions",                 default: 0
    t.integer  "total_contributions_without_matches", default: 0
    t.decimal  "total_payment_service_fee",           default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_project_totals_on_project_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_project_totals_project_id"
  end

  create_view "projects_for_home", " WITH featured_projects AS (\n         SELECT 'featured'::text AS origin,\n            featureds.id,\n            featureds.name,\n            featureds.user_id,\n            featureds.category_id,\n            featureds.goal,\n            featureds.about,\n            featureds.headline,\n            featureds.video_url,\n            featureds.short_url,\n            featureds.created_at,\n            featureds.updated_at,\n            featureds.about_html,\n            featureds.recommended,\n            featureds.home_page_comment,\n            featureds.permalink,\n            featureds.video_thumbnail,\n            featureds.state,\n            featureds.online_days,\n            featureds.online_date,\n            featureds.how_know,\n            featureds.more_urls AS more_links,\n            featureds.first_contributions,\n            featureds.uploaded_image,\n            featureds.video_embed_url,\n            featureds.budget,\n            featureds.budget_html,\n            featureds.terms,\n            featureds.terms_html,\n            featureds.site,\n            featureds.hash_tag,\n            featureds.address_city,\n            featureds.address_state,\n            featureds.address_zip_code,\n            featureds.address_neighborhood,\n            featureds.foundation_widget,\n            featureds.campaign_type,\n            featureds.featured,\n            featureds.home_page,\n            featureds.about_textile,\n            featureds.budget_textile,\n            featureds.terms_textile,\n            featureds.latitude,\n            featureds.longitude,\n            featureds.referral_url AS referal_link,\n            featureds.hero_image,\n            featureds.sent_to_analysis_at,\n            featureds.organization_type,\n            featureds.street_address\n           FROM projects featureds\n          WHERE (featureds.featured AND ((featureds.state)::text = 'online'::text))\n         LIMIT 1\n        ), recommended_projects AS (\n         SELECT 'recommended'::text AS origin,\n            recommends.id,\n            recommends.name,\n            recommends.user_id,\n            recommends.category_id,\n            recommends.goal,\n            recommends.about,\n            recommends.headline,\n            recommends.video_url,\n            recommends.short_url,\n            recommends.created_at,\n            recommends.updated_at,\n            recommends.about_html,\n            recommends.recommended,\n            recommends.home_page_comment,\n            recommends.permalink,\n            recommends.video_thumbnail,\n            recommends.state,\n            recommends.online_days,\n            recommends.online_date,\n            recommends.how_know,\n            recommends.more_urls AS more_links,\n            recommends.first_contributions,\n            recommends.uploaded_image,\n            recommends.video_embed_url,\n            recommends.budget,\n            recommends.budget_html,\n            recommends.terms,\n            recommends.terms_html,\n            recommends.site,\n            recommends.hash_tag,\n            recommends.address_city,\n            recommends.address_state,\n            recommends.address_zip_code,\n            recommends.address_neighborhood,\n            recommends.foundation_widget,\n            recommends.campaign_type,\n            recommends.featured,\n            recommends.home_page,\n            recommends.about_textile,\n            recommends.budget_textile,\n            recommends.terms_textile,\n            recommends.latitude,\n            recommends.longitude,\n            recommends.referral_url AS referal_link,\n            recommends.hero_image,\n            recommends.sent_to_analysis_at,\n            recommends.organization_type,\n            recommends.street_address\n           FROM projects recommends\n          WHERE (recommends.recommended AND ((recommends.state)::text = 'online'::text) AND recommends.home_page AND (NOT (recommends.id IN ( SELECT featureds.id\n                   FROM featured_projects featureds))))\n          ORDER BY (random())\n         LIMIT 5\n        ), expiring_projects AS (\n         SELECT 'expiring'::text AS origin,\n            expiring.id,\n            expiring.name,\n            expiring.user_id,\n            expiring.category_id,\n            expiring.goal,\n            expiring.about,\n            expiring.headline,\n            expiring.video_url,\n            expiring.short_url,\n            expiring.created_at,\n            expiring.updated_at,\n            expiring.about_html,\n            expiring.recommended,\n            expiring.home_page_comment,\n            expiring.permalink,\n            expiring.video_thumbnail,\n            expiring.state,\n            expiring.online_days,\n            expiring.online_date,\n            expiring.how_know,\n            expiring.more_urls AS more_links,\n            expiring.first_contributions,\n            expiring.uploaded_image,\n            expiring.video_embed_url,\n            expiring.budget,\n            expiring.budget_html,\n            expiring.terms,\n            expiring.terms_html,\n            expiring.site,\n            expiring.hash_tag,\n            expiring.address_city,\n            expiring.address_state,\n            expiring.address_zip_code,\n            expiring.address_neighborhood,\n            expiring.foundation_widget,\n            expiring.campaign_type,\n            expiring.featured,\n            expiring.home_page,\n            expiring.about_textile,\n            expiring.budget_textile,\n            expiring.terms_textile,\n            expiring.latitude,\n            expiring.longitude,\n            expiring.referral_url AS referal_link,\n            expiring.hero_image,\n            expiring.sent_to_analysis_at,\n            expiring.organization_type,\n            expiring.street_address\n           FROM projects expiring\n          WHERE (((expiring.state)::text = 'online'::text) AND (expires_at(expiring.*) <= (now() + '14 days'::interval)) AND expiring.home_page AND (NOT (expiring.id IN ( SELECT recommends.id\n                   FROM recommended_projects recommends\n                UNION\n                 SELECT featureds.id\n                   FROM featured_projects featureds))))\n          ORDER BY (random())\n         LIMIT 4\n        ), soon_projects AS (\n         SELECT 'soon'::text AS origin,\n            soon.id,\n            soon.name,\n            soon.user_id,\n            soon.category_id,\n            soon.goal,\n            soon.about,\n            soon.headline,\n            soon.video_url,\n            soon.short_url,\n            soon.created_at,\n            soon.updated_at,\n            soon.about_html,\n            soon.recommended,\n            soon.home_page_comment,\n            soon.permalink,\n            soon.video_thumbnail,\n            soon.state,\n            soon.online_days,\n            soon.online_date,\n            soon.how_know,\n            soon.more_urls AS more_links,\n            soon.first_contributions,\n            soon.uploaded_image,\n            soon.video_embed_url,\n            soon.budget,\n            soon.budget_html,\n            soon.terms,\n            soon.terms_html,\n            soon.site,\n            soon.hash_tag,\n            soon.address_city,\n            soon.address_state,\n            soon.address_zip_code,\n            soon.address_neighborhood,\n            soon.foundation_widget,\n            soon.campaign_type,\n            soon.featured,\n            soon.home_page,\n            soon.about_textile,\n            soon.budget_textile,\n            soon.terms_textile,\n            soon.latitude,\n            soon.longitude,\n            soon.referral_url AS referal_link,\n            soon.hero_image,\n            soon.sent_to_analysis_at,\n            soon.organization_type,\n            soon.street_address\n           FROM projects soon\n          WHERE (((soon.state)::text = 'soon'::text) AND soon.home_page AND (soon.uploaded_image IS NOT NULL))\n          ORDER BY (random())\n         LIMIT 4\n        ), successful_projects AS (\n         SELECT 'successful'::text AS origin,\n            successful.id,\n            successful.name,\n            successful.user_id,\n            successful.category_id,\n            successful.goal,\n            successful.about,\n            successful.headline,\n            successful.video_url,\n            successful.short_url,\n            successful.created_at,\n            successful.updated_at,\n            successful.about_html,\n            successful.recommended,\n            successful.home_page_comment,\n            successful.permalink,\n            successful.video_thumbnail,\n            successful.state,\n            successful.online_days,\n            successful.online_date,\n            successful.how_know,\n            successful.more_urls AS more_links,\n            successful.first_contributions,\n            successful.uploaded_image,\n            successful.video_embed_url,\n            successful.budget,\n            successful.budget_html,\n            successful.terms,\n            successful.terms_html,\n            successful.site,\n            successful.hash_tag,\n            successful.address_city,\n            successful.address_state,\n            successful.address_zip_code,\n            successful.address_neighborhood,\n            successful.foundation_widget,\n            successful.campaign_type,\n            successful.featured,\n            successful.home_page,\n            successful.about_textile,\n            successful.budget_textile,\n            successful.terms_textile,\n            successful.latitude,\n            successful.longitude,\n            successful.referral_url AS referal_link,\n            successful.hero_image,\n            successful.sent_to_analysis_at,\n            successful.organization_type,\n            successful.street_address\n           FROM projects successful\n          WHERE (((successful.state)::text = 'successful'::text) AND successful.home_page)\n          ORDER BY (random())\n         LIMIT 4\n        )\n SELECT featured_projects.origin,\n    featured_projects.id,\n    featured_projects.name,\n    featured_projects.user_id,\n    featured_projects.category_id,\n    featured_projects.goal,\n    featured_projects.about,\n    featured_projects.headline,\n    featured_projects.video_url,\n    featured_projects.short_url,\n    featured_projects.created_at,\n    featured_projects.updated_at,\n    featured_projects.about_html,\n    featured_projects.recommended,\n    featured_projects.home_page_comment,\n    featured_projects.permalink,\n    featured_projects.video_thumbnail,\n    featured_projects.state,\n    featured_projects.online_days,\n    featured_projects.online_date,\n    featured_projects.how_know,\n    featured_projects.more_links,\n    featured_projects.first_contributions,\n    featured_projects.uploaded_image,\n    featured_projects.video_embed_url,\n    featured_projects.budget,\n    featured_projects.budget_html,\n    featured_projects.terms,\n    featured_projects.terms_html,\n    featured_projects.site,\n    featured_projects.hash_tag,\n    featured_projects.address_city,\n    featured_projects.address_state,\n    featured_projects.address_zip_code,\n    featured_projects.address_neighborhood,\n    featured_projects.foundation_widget,\n    featured_projects.campaign_type,\n    featured_projects.featured,\n    featured_projects.home_page,\n    featured_projects.about_textile,\n    featured_projects.budget_textile,\n    featured_projects.terms_textile,\n    featured_projects.latitude,\n    featured_projects.longitude,\n    featured_projects.referal_link,\n    featured_projects.hero_image,\n    featured_projects.sent_to_analysis_at,\n    featured_projects.organization_type,\n    featured_projects.street_address\n   FROM featured_projects\nUNION\n SELECT recommended_projects.origin,\n    recommended_projects.id,\n    recommended_projects.name,\n    recommended_projects.user_id,\n    recommended_projects.category_id,\n    recommended_projects.goal,\n    recommended_projects.about,\n    recommended_projects.headline,\n    recommended_projects.video_url,\n    recommended_projects.short_url,\n    recommended_projects.created_at,\n    recommended_projects.updated_at,\n    recommended_projects.about_html,\n    recommended_projects.recommended,\n    recommended_projects.home_page_comment,\n    recommended_projects.permalink,\n    recommended_projects.video_thumbnail,\n    recommended_projects.state,\n    recommended_projects.online_days,\n    recommended_projects.online_date,\n    recommended_projects.how_know,\n    recommended_projects.more_links,\n    recommended_projects.first_contributions,\n    recommended_projects.uploaded_image,\n    recommended_projects.video_embed_url,\n    recommended_projects.budget,\n    recommended_projects.budget_html,\n    recommended_projects.terms,\n    recommended_projects.terms_html,\n    recommended_projects.site,\n    recommended_projects.hash_tag,\n    recommended_projects.address_city,\n    recommended_projects.address_state,\n    recommended_projects.address_zip_code,\n    recommended_projects.address_neighborhood,\n    recommended_projects.foundation_widget,\n    recommended_projects.campaign_type,\n    recommended_projects.featured,\n    recommended_projects.home_page,\n    recommended_projects.about_textile,\n    recommended_projects.budget_textile,\n    recommended_projects.terms_textile,\n    recommended_projects.latitude,\n    recommended_projects.longitude,\n    recommended_projects.referal_link,\n    recommended_projects.hero_image,\n    recommended_projects.sent_to_analysis_at,\n    recommended_projects.organization_type,\n    recommended_projects.street_address\n   FROM recommended_projects\nUNION\n SELECT expiring_projects.origin,\n    expiring_projects.id,\n    expiring_projects.name,\n    expiring_projects.user_id,\n    expiring_projects.category_id,\n    expiring_projects.goal,\n    expiring_projects.about,\n    expiring_projects.headline,\n    expiring_projects.video_url,\n    expiring_projects.short_url,\n    expiring_projects.created_at,\n    expiring_projects.updated_at,\n    expiring_projects.about_html,\n    expiring_projects.recommended,\n    expiring_projects.home_page_comment,\n    expiring_projects.permalink,\n    expiring_projects.video_thumbnail,\n    expiring_projects.state,\n    expiring_projects.online_days,\n    expiring_projects.online_date,\n    expiring_projects.how_know,\n    expiring_projects.more_links,\n    expiring_projects.first_contributions,\n    expiring_projects.uploaded_image,\n    expiring_projects.video_embed_url,\n    expiring_projects.budget,\n    expiring_projects.budget_html,\n    expiring_projects.terms,\n    expiring_projects.terms_html,\n    expiring_projects.site,\n    expiring_projects.hash_tag,\n    expiring_projects.address_city,\n    expiring_projects.address_state,\n    expiring_projects.address_zip_code,\n    expiring_projects.address_neighborhood,\n    expiring_projects.foundation_widget,\n    expiring_projects.campaign_type,\n    expiring_projects.featured,\n    expiring_projects.home_page,\n    expiring_projects.about_textile,\n    expiring_projects.budget_textile,\n    expiring_projects.terms_textile,\n    expiring_projects.latitude,\n    expiring_projects.longitude,\n    expiring_projects.referal_link,\n    expiring_projects.hero_image,\n    expiring_projects.sent_to_analysis_at,\n    expiring_projects.organization_type,\n    expiring_projects.street_address\n   FROM expiring_projects\nUNION\n SELECT soon_projects.origin,\n    soon_projects.id,\n    soon_projects.name,\n    soon_projects.user_id,\n    soon_projects.category_id,\n    soon_projects.goal,\n    soon_projects.about,\n    soon_projects.headline,\n    soon_projects.video_url,\n    soon_projects.short_url,\n    soon_projects.created_at,\n    soon_projects.updated_at,\n    soon_projects.about_html,\n    soon_projects.recommended,\n    soon_projects.home_page_comment,\n    soon_projects.permalink,\n    soon_projects.video_thumbnail,\n    soon_projects.state,\n    soon_projects.online_days,\n    soon_projects.online_date,\n    soon_projects.how_know,\n    soon_projects.more_links,\n    soon_projects.first_contributions,\n    soon_projects.uploaded_image,\n    soon_projects.video_embed_url,\n    soon_projects.budget,\n    soon_projects.budget_html,\n    soon_projects.terms,\n    soon_projects.terms_html,\n    soon_projects.site,\n    soon_projects.hash_tag,\n    soon_projects.address_city,\n    soon_projects.address_state,\n    soon_projects.address_zip_code,\n    soon_projects.address_neighborhood,\n    soon_projects.foundation_widget,\n    soon_projects.campaign_type,\n    soon_projects.featured,\n    soon_projects.home_page,\n    soon_projects.about_textile,\n    soon_projects.budget_textile,\n    soon_projects.terms_textile,\n    soon_projects.latitude,\n    soon_projects.longitude,\n    soon_projects.referal_link,\n    soon_projects.hero_image,\n    soon_projects.sent_to_analysis_at,\n    soon_projects.organization_type,\n    soon_projects.street_address\n   FROM soon_projects\nUNION\n SELECT successful_projects.origin,\n    successful_projects.id,\n    successful_projects.name,\n    successful_projects.user_id,\n    successful_projects.category_id,\n    successful_projects.goal,\n    successful_projects.about,\n    successful_projects.headline,\n    successful_projects.video_url,\n    successful_projects.short_url,\n    successful_projects.created_at,\n    successful_projects.updated_at,\n    successful_projects.about_html,\n    successful_projects.recommended,\n    successful_projects.home_page_comment,\n    successful_projects.permalink,\n    successful_projects.video_thumbnail,\n    successful_projects.state,\n    successful_projects.online_days,\n    successful_projects.online_date,\n    successful_projects.how_know,\n    successful_projects.more_links,\n    successful_projects.first_contributions,\n    successful_projects.uploaded_image,\n    successful_projects.video_embed_url,\n    successful_projects.budget,\n    successful_projects.budget_html,\n    successful_projects.terms,\n    successful_projects.terms_html,\n    successful_projects.site,\n    successful_projects.hash_tag,\n    successful_projects.address_city,\n    successful_projects.address_state,\n    successful_projects.address_zip_code,\n    successful_projects.address_neighborhood,\n    successful_projects.foundation_widget,\n    successful_projects.campaign_type,\n    successful_projects.featured,\n    successful_projects.home_page,\n    successful_projects.about_textile,\n    successful_projects.budget_textile,\n    successful_projects.terms_textile,\n    successful_projects.latitude,\n    successful_projects.longitude,\n    successful_projects.referal_link,\n    successful_projects.hero_image,\n    successful_projects.sent_to_analysis_at,\n    successful_projects.organization_type,\n    successful_projects.street_address\n   FROM successful_projects", :force => true
  create_view "recommendations", " SELECT recommendations.user_id,\n    recommendations.project_id,\n    (sum(recommendations.count))::bigint AS count\n   FROM ( SELECT b.user_id,\n            recommendations_1.id AS project_id,\n            count(DISTINCT recommenders.user_id) AS count\n           FROM ((((contributions b\n             JOIN projects p ON ((p.id = b.project_id)))\n             JOIN contributions backers_same_projects ON ((p.id = backers_same_projects.project_id)))\n             JOIN contributions recommenders ON ((recommenders.user_id = backers_same_projects.user_id)))\n             JOIN projects recommendations_1 ON ((recommendations_1.id = recommenders.project_id)))\n          WHERE (((b.state)::text = 'confirmed'::text) AND ((backers_same_projects.state)::text = 'confirmed'::text) AND ((recommenders.state)::text = 'confirmed'::text) AND (b.user_id <> backers_same_projects.user_id) AND (recommendations_1.id <> b.project_id) AND ((recommendations_1.state)::text = 'online'::text) AND (NOT (EXISTS ( SELECT true AS bool\n                   FROM contributions b2\n                  WHERE (((b2.state)::text = 'confirmed'::text) AND (b2.user_id = b.user_id) AND (b2.project_id = recommendations_1.id))))))\n          GROUP BY b.user_id, recommendations_1.id\n        UNION\n         SELECT b.user_id,\n            recommendations_1.id AS project_id,\n            0 AS count\n           FROM ((contributions b\n             JOIN projects p ON ((b.project_id = p.id)))\n             JOIN projects recommendations_1 ON ((recommendations_1.category_id = p.category_id)))\n          WHERE (((b.state)::text = 'confirmed'::text) AND ((recommendations_1.state)::text = 'online'::text))) recommendations\n  WHERE (NOT (EXISTS ( SELECT true AS bool\n           FROM contributions b2\n          WHERE (((b2.state)::text = 'confirmed'::text) AND (b2.user_id = recommendations.user_id) AND (b2.project_id = recommendations.project_id)))))\n  GROUP BY recommendations.user_id, recommendations.project_id\n  ORDER BY ((sum(recommendations.count))::bigint) DESC", :force => true
  create_table "routing_numbers", force: true do |t|
    t.string   "number"
    t.string   "bank_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name",       null: false
    t.string   "acronym",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.index ["acronym"], :name => "states_acronym_unique", :unique => true
  end

  create_view "subscriber_reports", " SELECT u.id,\n    cs.channel_id,\n    u.name,\n    u.email\n   FROM (users u\n     JOIN channels_subscribers cs ON ((cs.user_id = u.id)))", :force => true
  create_table "taggings", force: true do |t|
    t.integer  "tag_id",     null: false
    t.integer  "project_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project_id"], :name => "index_taggings_on_project_id"
    t.index ["tag_id"], :name => "index_taggings_on_tag_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_taggings_project_id"
    t.foreign_key ["tag_id"], "tags", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_taggings_tag_id"
  end

  create_table "total_backed_ranges", id: false, force: true do |t|
    t.text    "name",  null: false
    t.decimal "lower"
    t.decimal "upper"
  end

  create_table "unsubscribes", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], :name => "index_unsubscribes_on_project_id"
    t.index ["user_id"], :name => "index_unsubscribes_on_user_id"
    t.foreign_key ["project_id"], "projects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "unsubscribes_project_id_fk"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "unsubscribes_user_id_fk"
  end

  create_view "user_totals", " SELECT b.user_id AS id,\n    b.user_id,\n    count(DISTINCT b.project_id) AS total_contributed_projects,\n    sum(b.value) AS sum,\n    count(*) AS count,\n    sum(\n        CASE\n            WHEN (((p.state)::text <> 'failed'::text) AND (NOT b.credits)) THEN (0)::numeric\n            WHEN (((p.state)::text = 'failed'::text) AND b.credits) THEN (0)::numeric\n            WHEN (((p.state)::text = 'failed'::text) AND ((((b.state)::text = ANY (ARRAY[('requested_refund'::character varying)::text, ('refunded'::character varying)::text])) AND (NOT b.credits)) OR (b.credits AND (NOT ((b.state)::text = ANY (ARRAY[('requested_refund'::character varying)::text, ('refunded'::character varying)::text])))))) THEN (0)::numeric\n            WHEN (((p.state)::text = 'failed'::text) AND (NOT b.credits) AND ((b.state)::text = 'confirmed'::text)) THEN b.value\n            ELSE (b.value * ('-1'::integer)::numeric)\n        END) AS credits\n   FROM (contributions b\n     JOIN projects p ON ((b.project_id = p.id)))\n  WHERE ((b.state)::text = ANY (ARRAY[('confirmed'::character varying)::text, ('requested_refund'::character varying)::text, ('refunded'::character varying)::text]))\n  GROUP BY b.user_id", :force => true
  create_table "webhook_events", force: true do |t|
    t.hstore   "serialized_record"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wecashuptransactions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "transaction_uid"
    t.string   "transaction_token"
    t.string   "transaction_provider_name"
    t.string   "transaction_confirmation_code"
    t.integer  "contribution_id"
    t.string   "conversion_rate"
    t.string   "currency"
    t.string   "value"
    t.index ["contribution_id"], :name => "index_wecashuptransactions_on_contribution_id"
    t.foreign_key ["contribution_id"], "contributions", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_wecashuptransactions_contribution_id"
  end
end

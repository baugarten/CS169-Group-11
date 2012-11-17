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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121115232008) do

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "campaign_friends", :force => true do |t|
    t.string  "email"
    t.string  "name"
    t.integer "campaign_id"
    t.text    "email_template"
    t.text    "email_subject"
    t.integer "sent_count",     :default => 0
    t.integer "opened",         :default => 0
    t.string  "confirm_link",   :default => "No LINK"
  end

  add_index "campaign_friends", ["campaign_id"], :name => "index_campaign_friends_on_campaign_id"

  create_table "campaigns", :force => true do |t|
    t.string  "name"
    t.text    "template"
    t.string  "video_link"
    t.integer "priority"
    t.integer "user_id"
    t.integer "campaign_friends_id"
    t.integer "campaign_project_id"
    t.text    "email_subject"
  end

  add_index "campaigns", ["campaign_friends_id"], :name => "index_campaigns_on_campaign_friends_id"
  add_index "campaigns", ["campaign_project_id"], :name => "index_campaigns_on_campaign_project_id"
  add_index "campaigns", ["user_id"], :name => "index_campaigns_on_user_id"

  create_table "photos", :force => true do |t|
    t.string  "filename"
    t.string  "content_type"
    t.binary  "binary_data"
    t.integer "imageable_id"
    t.string  "imageable_type"
  end

  create_table "projects", :force => true do |t|
    t.string   "farmer"
    t.text     "description"
    t.integer  "target"
    t.decimal  "current"
    t.datetime "end_date"
    t.boolean  "ending"
    t.boolean  "completed"
    t.integer  "priority"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "campaign_id"
  end

  add_index "projects", ["campaign_id"], :name => "index_projects_on_campaign_id"

  create_table "updates", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name",             :default => ""
    t.string   "last_name",              :default => ""
    t.string   "nickname",               :default => ""
    t.integer  "campaign_id"
  end

  add_index "users", ["campaign_id"], :name => "index_users_on_campaign_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "video_id"
    t.integer  "recordable_id"
    t.string   "recordable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end

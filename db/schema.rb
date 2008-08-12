# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080811142159) do

  create_table "records", :force => true do |t|
    t.string "title"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "suffix"
    t.string "company"
    t.string "department"
    t.string "job_title"
    t.string "business_street"
    t.string "business_street_2"
    t.string "business_street_3"
    t.string "business_city"
    t.string "business_state"
    t.string "business_postal_code"
    t.string "business_country"
    t.string "home_street"
    t.string "home_street_2"
    t.string "home_street_3"
    t.string "home_city"
    t.string "home_state"
    t.string "home_postal_code"
    t.string "home_country"
    t.string "other_street"
    t.string "other_street_2"
    t.string "other_street_3"
    t.string "other_city"
    t.string "other_state"
    t.string "other_postal_code"
    t.string "other_country"
    t.string "assistants_phone"
    t.string "business_fax"
    t.string "business_phone"
    t.string "business_phone_2"
    t.string "callback_attribute"
    t.string "car_phone"
    t.string "company_main_phone"
    t.string "home_fax"
    t.string "home_phone"
    t.string "home_phone_2"
    t.string "isdn"
    t.string "mobile_phone"
    t.string "other_fax"
    t.string "other_phone"
    t.string "pager"
    t.string "primary_phone"
    t.string "radio_phone"
    t.string "ttytdd_phone"
    t.string "telex"
    t.string "account"
    t.string "anniversary"
    t.string "assistants_name"
    t.string "billing_information"
    t.string "birthday"
    t.string "business_address_po_box"
    t.string "category"
    t.string "children"
    t.string "directory_server"
    t.string "e_mail_address"
    t.string "e_mail_type"
    t.string "e_mail_display_name"
    t.string "e_mail_2_address"
    t.string "e_mail_2_type"
    t.string "e_mail_2_display_name"
    t.string "e_mail_3_address"
    t.string "e_mail_3_type"
    t.string "e_mail_3_display_name"
    t.string "gender"
    t.string "government_id_number"
    t.string "hobby"
    t.string "home_address_po_box"
    t.string "initial"
    t.string "internet_free_busy"
    t.string "keyword"
    t.string "language"
    t.string "location"
    t.string "managers_name"
    t.string "mileage"
    t.string "note"
    t.string "office_location"
    t.string "organizational_id_number"
    t.string "other_address_po_box"
    t.string "priority"
    t.string "private"
    t.string "profession"
    t.string "referred_by"
    t.string "sensitivity"
    t.string "spouse"
    t.string "user_1"
    t.string "user_2"
    t.string "user_3"
    t.string "user_4"
    t.string "web_page"
  end

end
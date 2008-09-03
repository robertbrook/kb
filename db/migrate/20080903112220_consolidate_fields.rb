class ConsolidateFields < ActiveRecord::Migration
  def self.up
    # add_column :records, :other_notes, :text
    # Record.reset_column_information
#
    # Record.all.each do |record|
      # other_notes = record_fields.collect do |field|
        # if field != :category
          # text = record.send(field).to_s.gsub("\r\n","\n")
          # text += "\n" unless text.blank?
          # text
        # else
          # ''
        # end
      # end.join('')
#
      # unless other_notes.blank?
        # record.other_notes = other_notes
        # record.save!
      # end
    # end
#
    # record_fields.each do |field|
      # remove_column :records, field
    # end
  end

  def self.down
    # record_fields.each do |field|
      # add_column :records, :field, :string
    # end
#
    # remove_column :records, :other_notes
  end

  def self.record_fields
    [ :company, :department, :job_title,
    :business_street, :business_street_2, :business_street_3, :business_city,
    :business_state, :business_postal_code, :business_country, :home_street,
    :home_street_2, :home_street_3, :home_city, :home_state, :home_postal_code,
    :home_country, :other_street, :other_street_2, :other_street_3, :other_city,
    :other_state, :other_postal_code, :other_country, :assistants_phone,
    :business_fax, :business_phone, :business_phone_2, :callback_attribute,
    :car_phone, :company_main_phone, :home_fax, :home_phone, :home_phone_2,
    :isdn, :mobile_phone, :other_fax, :other_phone, :pager, :primary_phone,
    :radio_phone, :ttytdd_phone, :telex, :account, :anniversary,
    :assistants_name, :billing_information, :birthday, :business_address_po_box,
    :category, :children, :directory_server, :e_mail_address, :e_mail_type,
    :e_mail_display_name, :e_mail_2_address, :e_mail_2_type,
    :e_mail_2_display_name, :e_mail_3_address, :e_mail_3_type,
    :e_mail_3_display_name, :government_id_number, :hobby, :home_address_po_box,
    :internet_free_busy, :keyword, :language, :location,
    :managers_name, :mileage, :office_location, :organizational_id_number,
    :other_address_po_box, :profession, :referred_by, :spouse, :user_1,
    :user_2, :user_3, :user_4 ]
  end
end

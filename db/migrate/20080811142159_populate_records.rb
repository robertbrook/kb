class PopulateRecords < ActiveRecord::Migration

  class << self
    def up
      file = File.dirname(__FILE__) + '/../../data/kbfile.csv'
      FasterCSV.foreach(file, :headers => :first_row) do |column_values|

        attributes = Hash.new
        column_values.each do |column_value|
          attribute = convert_to_attribute(column_value[0])
          unless ignore_field? attribute
            value = clean_value(attribute, column_value[1])
            attributes[attribute] = value
          end
        end

        begin
          unless is_letter_index? attributes
            record = create_record attributes
            record.save!
          end
        rescue Exception => e
          puts attributes.inspect
          raise e
        end
      end
    end

    def ignore_field? attribute
      ignore_fields = [:gender, :private, :priority, :sensitivity, :initial]
      ignore_fields.include? attribute
    end

    def create_record attributes
      consolidate_attributes(attributes)
      Record.new(attributes)
    end

    def is_letter_index? attributes
      (attributes[:first_name].blank? || attributes[:first_name].to_s.size == 1) && attributes[:notes].blank?
    end

    def clean_value attribute, value
      (value == '0/0/00') ? nil : value
    end

    def convert_to_attribute column
      column.to_s.tableize.tr(' ','_').tr("'",'').tr('/','').singularize.sub('faxis','fax').sub('note','notes').sub(/^callback/,'callback_attribute').to_sym
    end

    def consolidate_attributes attributes
      other_notes = record_fields.collect do |field|
        if (field != :category) && (value = attributes.delete(field))
          text = value.to_s.gsub("\r\n","\n")
          text += "\n" unless text.blank?
          text
        else
          ''
        end
      end.join('')

      attributes[:other_notes] = other_notes
    end

    def record_fields
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

    def down
      Record.delete_all
    end
  end
end

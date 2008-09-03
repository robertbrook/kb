class CreateRecords < ActiveRecord::Migration

  def self.up
    create_table :records do |t|
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :category
      t.text   :notes
      t.text   :other_notes
      t.string :web_page

      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end

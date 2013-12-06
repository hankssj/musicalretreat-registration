class AddPhoneColumnsToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :home_phone, :string
    add_column :registrations, :cell_phone, :string
    add_column :registrations, :work_phone, :string
  end

  def self.down
    remove_column :registrations, :work_phone
    remove_column :registrations, :cell_phone
    remove_column :registrations, :home_phone
  end
end

class AddCountryColumnToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :country, :string, :default => "US"
  end

  def self.down
    remove_column :registrations, :country
  end
end

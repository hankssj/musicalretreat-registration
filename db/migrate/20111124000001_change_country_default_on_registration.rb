class ChangeCountryDefaultOnRegistration < ActiveRecord::Migration
  def self.up
    change_column :registrations, :country, :string, :default => "USA"
  end

  def self.down
    change_column :registrations, :country, :string, :default => "US"
  end
end

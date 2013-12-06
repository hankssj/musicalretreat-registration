class AddCountryFieldToCancellations < ActiveRecord::Migration
  def self.up
    add_column :cancellations, :country, :string, :default => "US"
  end

  def self.down
    remove_column :cancellations, :country
  end
end

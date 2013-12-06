class AddFacultyColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :faculty, :boolean, :default => false
  end

  def self.down
    remove_column :users, :faculty
  end
end

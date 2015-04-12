class AddTestToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :test, :boolean, default: false
  end
end

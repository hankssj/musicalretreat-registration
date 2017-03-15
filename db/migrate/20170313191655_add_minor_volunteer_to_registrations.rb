class AddMinorVolunteerToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :minor_volunteer, :boolean
  end
end

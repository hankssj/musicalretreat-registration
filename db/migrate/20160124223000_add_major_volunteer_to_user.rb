class AddMajorVolunteerToUser < ActiveRecord::Migration
  def change
    add_column :users, :major_volunteer, :boolean, default: false
  end
end

class AddDormAssignmentToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :dorm_assignment, :string
  end
end

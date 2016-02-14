class AddActiveToUser < ActiveRecord::Migration
  def change
    add_column :electives, :active, :boolean, default: true
  end
end

class CreateElectives < ActiveRecord::Migration
  def change
    create_table :electives do |t|
      t.string :name
      t.string :instructor
      t.string :description

      t.timestamps
    end
  end
end

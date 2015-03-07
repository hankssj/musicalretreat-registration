class CreateElectives < ActiveRecord::Migration
  def change
    create_table :electives do |t|
      t.string :name
      t.string :instructor
      t.text :description

      t.timestamps
    end
  end
end

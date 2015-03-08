class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :display_name
      t.string :large_ensemble
      t.string :evaluation_class
      t.boolean :closed, :default => false

      t.timestamps
    end
  end
end

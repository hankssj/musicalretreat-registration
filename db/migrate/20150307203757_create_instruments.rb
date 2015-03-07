class CreateInstruments < ActiveRecord::Migration
  def change
    create_table :instruments do |t|
      t.string :display_name
      t.boolean :closed

      t.timestamps
    end
  end
end

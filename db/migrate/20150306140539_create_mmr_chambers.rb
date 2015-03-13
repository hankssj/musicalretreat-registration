class CreateMmrChambers < ActiveRecord::Migration
  def change
    create_table :mmr_chambers do |t|
      t.column :ensemble_primary_id, :int
      t.column :instrument_id, :int
      t.column :string_novice, :boolean
      t.column :jazz_ensemble, :boolean
      t.column :notes, :text
      t.timestamps
    end
  end
end

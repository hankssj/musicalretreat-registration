class CreateMmrChambers < ActiveRecord::Migration
  def change
    create_table :mmr_chambers do |t|
      t.int :ensemble_primary_id
      t.int :instrument_id_1
      t.boolean :string_novice
      t.boolean :jazz_ensemble

      t.timestamps
    end
  end
end

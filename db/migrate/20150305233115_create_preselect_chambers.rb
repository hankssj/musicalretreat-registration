class CreatePreselectChambers < ActiveRecord::Migration
  def change
    create_table :preselect_chambers do |t|
      t.int :ensemble_primary_id
      t.string :contact_name
      t.string :string
      t.string :contact_phone
      t.string :name_1
      t.int :instrument_id_1
      t.string :name_2
      t.int :instrument_id_2
      t.string :name_3
      t.int :instrument_id_3
      t.string :name_4
      t.int :instrument_id_4
      t.string :name_5
      t.int :instrument_id_5
      t.boolean :bring_own_music
      t.string :music_name
      t.string :music_composer

      t.timestamps
    end
  end
end

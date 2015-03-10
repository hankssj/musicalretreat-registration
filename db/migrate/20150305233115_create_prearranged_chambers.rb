class CreatePrearrangedChambers < ActiveRecord::Migration
  def change
    create_table :prearranged_chambers do |t|
      t.integer :ensemble_primary_id
      t.boolean :i_am_contact
      t.string  :contact_name
      t.integer :instrument_id
      t.text    :participant_names
      t.boolean :bring_own_music
      t.string  :music_composer_and_name
      t.timestamps
    end
  end
end



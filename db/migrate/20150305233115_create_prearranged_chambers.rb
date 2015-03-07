class CreatePrearrangedChambers < ActiveRecord::Migration
  def change
    create_table :prearranged_chambers do |t|
      t.column :ensemble_primary_id, :int
      t.column :contact_name, :string
      t.column :string, :string
      t.column :contact_phone, :string
      t.column :name_1, :string
      t.column :instrument_id_1, :int
      t.column :name_2, :string
      t.column :instrument_id_2, :int
      t.column :name_3, :string
      t.column :instrument_id_3, :int
      t.column :name_4, :string
      t.column :instrument_id_4, :int
      t.column :name_5, :string
      t.column :instrument_id_5, :int
      t.column :bring_own_music, :boolean
      t.column :music_name, :string
      t.column :music_composer, :string

      t.timestamps
    end
  end
end



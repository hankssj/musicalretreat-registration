# class CreatePreselectChambers < ActiveRecord::Migration
#   def change
#     create_table :preselect_chambers do |t|
#       t.int :ensemble_primary_id
#       t.string :contact_name
#       t.string :string
#       t.string :contact_phone
#       t.string :name_1
#       t.int :instrument_id_1
#       t.string :name_2
#       t.int :instrument_id_2
#       t.string :name_3
#       t.int :instrument_id_3
#       t.string :name_4
#       t.int :instrument_id_4
#       t.string :name_5
#       t.int :instrument_id_5
#       t.boolean :bring_own_music
#       t.string :music_name
#       t.string :music_composer

#       t.timestamps
#     end
#   end
# end

class CreatePrearrangedChambers < ActiveRecord::Migration
  def change
    create_table :preselect_chambers do |t|
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



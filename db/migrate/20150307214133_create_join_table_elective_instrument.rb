class CreateJoinTableElectiveInstrument < ActiveRecord::Migration
  def change
    create_join_table :electives, :instruments do |t|
       t.index [:elective_id, :instrument_id]
       t.index [:instrument_id, :elective_id]
    end
  end
end

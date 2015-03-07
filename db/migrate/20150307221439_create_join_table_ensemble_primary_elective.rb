class CreateJoinTableEnsemblePrimaryElective < ActiveRecord::Migration
  def change
    create_join_table :ensemble_primaries, :electives do |t|
      t.integer :rank
      t.index [:ensemble_primary_id, :elective_id]
      t.index [:elective_id, :ensemble_primary_id]
    end
  end
end

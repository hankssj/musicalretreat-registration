class CreateInvitees < ActiveRecord::Migration
  def self.up
    create_table :invitees do |t|
      t.string :email,      :null => false
      t.sent_at :time
      t.timestamps
    end
  end

  def self.down
    drop_table :invitees
  end
end

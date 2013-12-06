class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,            :null => false
      t.boolean   :admin,            :default => false
      t.string    :hashed_password,  :null => false
      t.string    :salt,             :null => false
      t.boolean   :board,            :default => false
      t.boolean   :registrar,        :default => false
      t.time      :bounced_at
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

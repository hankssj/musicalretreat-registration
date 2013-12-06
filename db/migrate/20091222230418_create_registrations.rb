class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |r|
      create_table :cancellations do |c|

        [r,c].each{|t|t.string :year,        :null => false}
        [r,c].each{|t|t.integer :user_id,    :null => false}
        [r,c].each{|t|t.string :first_name}
        [r,c].each{|t|t.string :last_name}
        [r,c].each{|t|t.string :street1}
        [r,c].each{|t|t.string :street2}
        [r,c].each{|t|t.string :city}
        [r,c].each{|t|t.string :state}
        [r,c].each{|t|t.string :country,    :default => "US"}
        [r,c].each{|t|t.string :zip}
        [r,c].each{|t|t.string :primaryphone}
        [r,c].each{|t|t.string :secondaryphone}
        [r,c].each{|t|t.string :emergency_contact_name}
        [r,c].each{|t|t.string :emergency_contact_phone}
        [r,c].each{|t|t.boolean :firsttime,    :default => false}
        [r,c].each{|t|t.boolean :mailinglist,  :default => true}
        [r,c].each{|t|t.boolean :donotpublish, :default => false}
        [r,c].each{|t|t.boolean :dorm,         :default => true}
        [r,c].each{|t|t.string :share_housing_with}
        [r,c].each{|t|t.boolean :meals,        :default => true}
        [r,c].each{|t|t.boolean :vegetarian,   :default => false}
        [r,c].each{|t|t.string :gender,        :default => "F"}
        [r,c].each{|t|t.boolean :participant,  :default => true}
        [r,c].each{|t|t.integer :instrument_id}
        [r,c].each{|t|t.boolean :monday, :default => false}
        [r,c].each{|t|t.integer :tshirtm, :default => 0}
        [r,c].each{|t|t.integer :tshirtl, :default => 0}
        [r,c].each{|t|t.integer :tshirtxl, :default => 0}
        [r,c].each{|t|t.integer :tshirtxxl, :default => 0}
        [r,c].each{|t|t.boolean :discount, :default => false}
        [r,c].each{|t|t.integer :donation, :default => 0}
        [r,c].each{|t|t.text :comments}
        [r,c].each{|t|t.boolean :aircond, :default => false}
        [r,c].each{|t|t.string :payment_mode, :default => "deposit_check"}
        [r,c].each{|t|t.timestamps}

        c.integer :registration_id

      end
    end
  end

  def self.down
    [:registrations, :cancellations].each{|t| drop_table t}
  end
end

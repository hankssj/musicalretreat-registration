class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |p|
      create_table :cancelled_payments do |c|
        [p,c].each{|t| t.integer    :registration_id, :null => false}
        [p,c].each{|t| t.decimal    :amount, :precision => 8, :scale => 2, :null => false}
        [p,c].each{|t| t.string     :check_number}
        [p,c].each{|t| t.string     :note}
        [p,c].each{|t| t.date       :date_received}
        [p,c].each{|t| t.boolean    :scholarship, :default => false}
        [p,c].each{|t| t.timestamps}
        c.integer :payment_id,   :null => false
      end
    end
  end

  def self.down
  end
end

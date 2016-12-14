class CreateMassEmails < ActiveRecord::Migration
  def change
    create_table :mass_emails do |t|
      t.string :email_address
      t.string :url_code
      t.datetime :bounced_at
      t.datetime :unsubscribed_at

      t.timestamps
    end
  end
end

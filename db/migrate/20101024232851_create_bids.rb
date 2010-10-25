class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.belongs_to :person
      t.string :zip
      t.timestamp :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end

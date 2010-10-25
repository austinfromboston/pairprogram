class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.belongs_to :person
      t.belongs_to :bid

      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end

class AddDisabledToPeopleAndBids < ActiveRecord::Migration
  def self.up
    add_column :people, :disabled, :boolean
    add_column :bids, :disabled, :boolean
  end

  def self.down
    remove_column :people, :disabled
    remove_column :bids, :disabled
  end
end

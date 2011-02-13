class PeopleHaveRoles < ActiveRecord::Migration
  def self.up
    rename_column :offers, :person_id, :sender_id
    rename_column :bids, :person_id, :bidder_id
  end

  def self.down
    rename_column :offers, :sender_id, :person_id
    rename_column :bids, :bidder_id, :person_id
  end
end

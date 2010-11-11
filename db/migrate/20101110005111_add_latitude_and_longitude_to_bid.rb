class AddLatitudeAndLongitudeToBid < ActiveRecord::Migration
  def self.up
    add_column :bids, :latitude, :float
    add_column :bids, :longitude, :float
  end

  def self.down
    remove_column :bids, :longitude
    remove_column :bids, :latitude
  end
end

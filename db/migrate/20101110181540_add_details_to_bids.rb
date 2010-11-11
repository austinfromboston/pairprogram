class AddDetailsToBids < ActiveRecord::Migration
  def self.up
    add_column :bids, :availability, :text
    add_column :bids, :skills, :text
    add_column :bids, :project_description, :text
  end

  def self.down
    remove_column :bids, :project_description
    remove_column :bids, :skills
    remove_column :bids, :availability
  end
end

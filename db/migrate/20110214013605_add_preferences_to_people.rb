class AddPreferencesToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :allow_email, :boolean
  end

  def self.down
    remove_column :people, :allow_email
  end
end

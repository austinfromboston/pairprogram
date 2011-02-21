class AddSuperuserToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :superuser, :boolean
  end

  def self.down
    remove_column :people, :superuser
  end
end

class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.string :service
      t.string :identity_key
      t.text :info
      t.belongs_to :person

      t.timestamps
    end
  end

  def self.down
    drop_table :identities
  end
end

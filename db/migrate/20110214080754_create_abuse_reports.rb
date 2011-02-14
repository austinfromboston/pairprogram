class CreateAbuseReports < ActiveRecord::Migration
  def self.up
    create_table :abuse_reports do |t|
      t.string :reason
      t.text :description
      t.belongs_to :bid

      t.timestamps
    end
  end

  def self.down
    drop_table :abuse_reports
  end
end

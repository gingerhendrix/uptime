class CreatePings < ActiveRecord::Migration
  def self.up
    create_table :pings do |t|
      t.column :created_at, :datetime
      t.column :site_id, :integer
      t.column :response_time, :integer
      t.column :response_code, :integer
      t.column :response_text, :string
    end
  end

  def self.down
    drop_table :pings
  end
end

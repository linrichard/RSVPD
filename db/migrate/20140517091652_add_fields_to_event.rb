class AddFieldsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :name, :string
    add_column :events, :description, :text
    add_column :events, :location_id, :integer
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
    add_column :events, :privacy, :integer
    add_column :events, :price, :float
    add_column :events, :phone, :string
    add_column :events, :website, :string
  end

  def self.down
    remove_column :events, :name
    remove_column :events, :description
    remove_column :events, :location_id
    remove_column :events, :start_time
    remove_column :events, :end_time
    remove_column :events, :privacy
    remove_column :events, :price
    remove_column :events, :phone
    remove_column :events, :website
  end
end

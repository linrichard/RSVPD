class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :actor_id
      t.integer :receiver_id
      t.string :action
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
  end
end

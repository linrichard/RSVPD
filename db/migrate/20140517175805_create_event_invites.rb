class CreateEventInvites < ActiveRecord::Migration
  def change
    create_table :event_invites do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :phone
      t.integer :rsvp_status

      t.timestamps
    end
  end
end

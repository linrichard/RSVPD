class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :fb_event_id
      t.datetime :rsvp_deadline

      t.timestamps
    end
  end
end

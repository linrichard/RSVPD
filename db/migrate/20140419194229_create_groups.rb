class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :creator_id
      t.integer :privacy
      t.text :details

      t.timestamps
    end
  end
end

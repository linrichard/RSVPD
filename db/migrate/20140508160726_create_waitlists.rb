class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.string :email
      t.string :code
      t.integer :status

      t.timestamps
    end
  end
end

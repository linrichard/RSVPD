class AddStatusToGroupUser < ActiveRecord::Migration
  def self.up
    add_column :group_users, :status, :integer
  end

  def self.down
    remove_column :group_users, :status
  end
end

class RenameUserIdToFbUserId < ActiveRecord::Migration
  def self.up
    rename_column :group_users, :user_id, :fb_user_id
  end

  def self.down
    rename_column :group_users, :fb_user_id, :user_id
  end
end

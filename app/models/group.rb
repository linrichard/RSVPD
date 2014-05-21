class Group < ActiveRecord::Base


  STATUS = {
    :PENDING => 0,
    :ACCEPTED => 1,
    :REJECTED => 2
  }

  PRIVACY = {
    :CLOSED => 0,
    :OPEN => 1
  }

  def self.validate_and_create(creator, params)
    group_name = params[:name]
    group_desc = params[:desc]
    group_privacy = params[:privacy]
    group_members = params[:members]

    return nil if group_name.empty?
    return nil if group_desc.empty?
    return nil unless [0, 1].include? group_privacy.to_i

    fb_user_ids = group_members.split(",") # these are fb ids (of type string)

    # first create the group
    group = self.create({
      :creator_id => creator.id,
      :name => group_name,
      :privacy => group_privacy,
      :details => group_desc
    })

    logger.debug("HERE")
    logger.debug(group)

    invitations = group.invite_members(creator, fb_user_ids)

    return group
  end

  def invite_members(creator, fb_user_ids = [])
    logger.debug(fb_user_ids)
    fb_user_ids = fb_user_ids.uniq

    # invite those that haven't been invited to this group
    already_invited = GroupUser.where(["group_id = ? and fb_user_id in (?)", id, fb_user_ids])
    already_invited_ids = already_invited.map(&:fb_user_id)
    fb_user_ids.reject! { |id| already_invited_ids.include? id }

    # invite valid fb_user_ids
    invitations = []

    fb_user_ids.each do |fb_user_id|
      group_user = GroupUser.create({
        :group_id => id,
        :fb_user_id => fb_user_id,
        :status => STATUS[:ACCEPTED] # invitee is forced to accept for now
      })
      invitations.push group_user
    end

    invitations.push GroupUser.create({
      :group_id => id,
      :fb_user_id => creator.fb_user_id,
      :status => STATUS[:ACCEPTED] # invitee is forced to accept for now
    })

    return invitations
  end

  def members
    group_users_fb_ids = GroupUser.where(:group_id => id).map(&:fb_user_id)
    registered_members = User.where(["fb_user_id in (?)", group_users_fb_ids])
    registered_members_fb_ids = registered_members.map(&:fb_user_id)

    non_registered_members_fb_ids = group_users_fb_ids - registered_members_fb_ids

    # [TODO] for now we just return fb ids and then do another fetch client side
    members = group_users_fb_ids
    return members
  end
end

class Waitlist < ActiveRecord::Base
  validates :email, presence: true, email: true

  def self.enlist(email)
    return nil if email.blank?
    code = Digest::SHA1.hexdigest([Time.now, rand].join)[0..10]
    while Waitlist.where(:code => code).first.present?
      code = Digest::SHA1.hexdigest([Time.now, rand].join)[0..10]
    end

    waitlist = Waitlist.create({
      :email => email,
      :code => code,
      :status => 0
    })

    unless waitlist.save
      return nil
    end
    return waitlist
  end
end

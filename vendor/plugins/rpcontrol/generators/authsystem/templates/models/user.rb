class User < ActiveRecord::Base
  acts_as_authentic

  acts_as_user

  def to_label
    login
  end

end

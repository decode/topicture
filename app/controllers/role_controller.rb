class RoleController < ApplicationController
  layout "base"
  active_scaffold

  def conditions_for_collection
    ['role != ?', 'admin'] unless current_user.has_role? 'admin'
  end
end

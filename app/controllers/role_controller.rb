class RoleController < ApplicationController
  layout "base"
  active_scaffold
  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:permissions]
    #config.actions.exclude :nested
  end

  def conditions_for_collection
    ['role != ?', 'admin'] unless current_user.has_role? 'admin'
  end
end

class ManageMessageController < ApplicationController
  layout 'admin'

  active_scaffold :messages do | config |
    config.label = ''
    config.actions.exclude :create, :search
    config.columns = [:title, :body, :created_at, :updated_at]
    #config.columns[:messages].includes = [:messageboxes]
    #config.columns[:last_transaction_date].sort_by :sql => "user_transactions.created_at"
  end
  
  def conditions_for_collection
    #['login != ?', 'admin'] unless current_user.has_role? 'admin'
    return '' if session[:manage_type].nil?
    ['message_type = ?', session[:manage_type]]
  end
end

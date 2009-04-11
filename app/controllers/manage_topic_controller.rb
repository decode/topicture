class ManageTopicController < ApplicationController
  layout 'admin'

  active_scaffold :topics do | config |
    config.label = 'Topic List'
    config.columns = [:name, :description, :parent_topic]
  end
end

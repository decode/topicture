class PermissionController < ApplicationController
  layout "base"
  active_scaffold

  controller_accessor :create, :delete, :update, :show, :index
end

class PermissionController < ApplicationController
  layout "base"
  include AccessFilter
  active_scaffold

  controller_accessor :create, :delete, :update, :show, :index
end

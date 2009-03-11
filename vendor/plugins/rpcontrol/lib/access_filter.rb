# -*- coding: utf-8 -*-
module AccessFilter

  # using:
  #    include AccessFilter
  # to implements role control

  def self.included(base)
    base.send :before_filter, :access
    base.send :helper_method, :action_authorize?
    base.extend ClassMethods
  end

  module ClassMethods
    # this method extend the active_scaffold's permission controll.
    # 添加控制器方法,控制对ActiveScaffold的操作权限必须为已登录用户才能进行相关操作
    # 可以添加的配置项为 :create, :destroy, :update
    def controller_accessor(*symbols)
      symbols.each do |sym|
        class_eval %{
        def #{sym}_authorized?
          return action_authorize?("#{sym}")
        end
        }
      end
    end
  end # end mobule ClassMethods

  # for test if user can access some action resource from current controller. espicially in active_scaffold
  def action_authorize?(action_name)
    user = get_current_user

    isAccessible = false
    controller_name = self.controller_class_name.gsub( /Controller$/, '' ).downcase.gsub(/::/, '/')
    perms = Permission.find :all, :conditions => {:perm_resource => controller_name + "/" + action_name.downcase, :perm_type => "CA" }
    perms.each do |p|
      if user.has_permission? p.name
        isAccessible = true
        break
      end
    end
    return isAccessible
  end

  private

  def access
    unless can_access?
      redirect_to new_user_session_url
    end
  end

  def can_access?
    user = get_current_user
    return false if user.nil?

    #puts user.login
    #puts self.controller_class_name
    #puts self.action_name

    isAccessible = false

    controller_name = self.controller_class_name.gsub( /Controller$/, '' ).downcase.gsub(/::/, '/')
    perms = Permission.find :all, :conditions => {:perm_resource => controller_name, :perm_type => "C" }
    perms.each do |p|
      if user.has_permission? p.name
        isAccessible = true
        break
      end
    end

    return isAccessible if isAccessible

    perms = Permission.find :all, :conditions => {:perm_resource => self.action_name.downcase, :perm_type => "A" }
    perms.each do |p|
      if user.has_permission? p.name
        isAccessible = true
        break
      end
    end

    return isAccessible if isAccessible

    perms = Permission.find :all, :conditions => {:perm_resource => controller_name + "/" + self.action_name.downcase, :perm_type => "CA" }
    perms.each do |p|
      if user.has_permission? p.name
        isAccessible = true
        break
      end
    end

    return isAccessible
  end # end can_access?

  def get_current_user
    user = current_user
    unless user.instance_of? User
      # 有bug，如果current_user为空的时候，根据id可能会找到别的用户
      # update 2009-01-31
      begin
        user = User.find_by_id current_user.id
      rescue
        user = nil
      end
    end
    
    if user.nil?
      user = User.find_by_login "anonymous"
    end
    return user
  end

end




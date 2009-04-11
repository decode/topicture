Before do
  @role = Hash.new
end

Given /^Role (.*) can access controller (.*)$/ do |role, controller|
  @role[role] = Factory(:role, :name => role)
  @permission = Factory(:permission, :perm_resource => controller)
  @role[role].permissions << @permission
end

Given /^Role (.*) can view (.*) action (.*)$/ do |role, controller, action|
  @role[role] = Factory(:role, :name => role)
  @permission = Factory(:permission, :perm_resource => "#{controller}/#{action}", :perm_type => "CA")
  @role[role].permissions << @permission
end

Given /^I am logged in as (.*) named (.*)$/ do |role, name|
  @user = Factory(:user, :login => name)
  @user.roles << @role[role]

  visit new_user_session_url
  fill_in "Login", :with => name
  fill_in "Password", :with => "password"
  click_button "Login"
  #response.body.should =~ /Welcome/m
end

Given /^I logged in as a admin user (.*)$/ do |name|
  Given "Role admin can access controller messages"
  Given "Role admin can access controller users"
  Given "Role admin can access controller topics"
  Given "I am logged in as admin named #{name}"
end

Given /^I logged in as a normal user (.*)$/ do |name|
  Given "Role normal can access controller messages"
  Given "Role normal can access controller users"
  Given "Role normal can access controller topics"
  Given "I am logged in as normal named #{name}"
end

Given /^I logged in as a guest user (.*)$/ do |name|
  Given "Role anonymous can access controller messages"
  Given "Role anonymous can access controller users"
  Given "I am logged in as anonymous named #{name}" 
end

Given /^User (.*) has role named (.*)$/ do |name, role|
  Given "Role #{role} can access controller messages"
  Given "Role #{role} can access controller users"
  @user = Factory(:user, :login => name)
  @user.roles << @role[role]
end

Given /^I am on login page$/ do
  visit "/user_session/new"
end

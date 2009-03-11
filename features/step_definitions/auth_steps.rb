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

Given /^I am admin user$/ do
end

Given /^I am manage user$/ do
end

Given /^I am normal user$/ do
end

Given /^I am unlogged user$/ do
end

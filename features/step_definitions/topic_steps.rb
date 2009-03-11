Given /I am a unregistered user$/ do
end

When /^I goto the new topic page$/ do
  visit new_topic_url
end

Given /^I am the (\w+) user$/ do |name|
  @user = Factory(:user, :login => name)
  @role = Factory(:role, :name => name)
  @permission = Factory(:permission)
  @role.permissions << @permission
  @permission = Factory(:permission, :perm_resource => "messages")
  @role.permissions << @permission
  @user.roles << @role

  visit new_user_session_url
  fill_in "Login", :with => name
  fill_in "Password", :with => "password"
  click_button "Login"
end

Given /^I am on the new topic page$/ do
  visit new_topic_url
  response.body.should =~ /New topic/m
end

Given /^the following topics:$/ do |topics|
  Topic.create!(topics.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) topic$/ do |pos|
  visit topics_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following topics:$/ do |topics|
  topics.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.chomp.strip.should == cell
      }
    end
  end
end

Given /I am on a topic page/ do
  topic = Topic.create :name => "name 1"
  topic.save
  visit topics_url
  response.body.should =~ /Show/m
  click_link "Show"
end

When /^I click the "Post" link$/ do
  click_link "Post"
end

Given /I am on the topic page included 2 messages$/ do
  topic = Topic.create! :name => "topic 1"
  message = Message.new :title => "message 1"
  message.topic_id = topic.id
  message.save
  message = Message.new :title => "message 2"
  message.topic_id = topic.id
  message.save
  visit topics_url
  click_link "Show"
end

When /^I click the (\d+)(?:st|nd|rd|th) "Delete" link$/ do |pos|
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Delete"
  end
end

Given /I am on topic page with message title "(\w+)"$/ do |title|
  topic = Topic.create! :name => "topic 1"
  message = Message.new :title => title, :body => "message body"
  message.topic_id = topic.id
  message.save
  visit topics_url
  click_link "Show"
end

When /^I click the message title "(\w+)"$/ do |title|
  click_link title
end


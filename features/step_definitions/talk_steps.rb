Given /^I logged in as a message user (.*)$/ do |name|
  Given "Role normal can access controller messages"
  Given "Role normal can access controller users"
  Given "I am logged in as normal named #{name}"
end


Given /^I am on a page about user named (.*)$/ do |name|
  @user_to = Factory :user, :login => name, :email => "#{name}@mail.org"
  visit "/user/#{@user_to.login}"
  response.body.should =~ /User\'s first page/m
end

When /^I send a message$/ do
  click_link "message"
  fill_in "Title", :with => "hello"
  fill_in "Body", :with => "nice to meet you"
  click_button "Create"
end

Then /user (.*) should received a message from (.*)$/ do |receiver, sender|
  send_user = User.find_by_login(receiver)
  send_user.received_messages.count.should == 1
  msg = send_user.received_messages.find :first
  msg.user.login.should == sender
  from_user = User.find_by_login(sender)
  from_user.sent_messages.count.should == 1
end

Given /^I am on my message list page$/ do
  @user.login.should == "Jerry"
  visit "/user/#{@user.login}/panel"
end

Given /^the following list messages:$/ do |messages|
  messages.hashes.each do |m|
    user = Factory.create :user, :login => m["sender"], :email => "#{m["sender"]}@test.net" unless m["sender"].nil?
    message = Factory.create :message, :title => m["title"], :body => m["body"]
    message.user = user
    message.receivers << @user
    unless m[:status].nil?

    end
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) message from the list$/ do |pos|
  visit "/user/#{@user.login}/panel"
  within("table > tr:nth-child(#{pos.to_i})") do
    click_link "delete"
  end
end

Then /^I should see the follwing message list:$/ do |messages|
  messages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.chomp.strip.should == cell
      }
    end
  end
end


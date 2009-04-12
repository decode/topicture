Given /^I am on a page about user named (.*)$/ do |name|
  @user_to = Factory :user, :login => name, :email => "#{name}@mail.org"
  visit "/user/#{@user_to.login}"
  response.body.should =~ /#{@user_to.login}/m
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
  click_link "Message Box"
end

Given /^the following list messages:$/ do |messages|
  messages.hashes.each do |m|
    user = Factory.create :user, :login => m["sender"], :email => "#{m["sender"]}@test.net" unless m["sender"].nil?
    message = Factory.create :message, :title => m["title"], :body => m["body"]
    message.user = user
    message.receivers << @user
    message.message_type = 'message'
    message.save

    unless m[:status].nil?
      # Add code for initial message status
    end
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) message from the list$/ do |pos|
  visit "/user/#{current_user.login}/panel"
  within("table > tr:nth-child(#{pos.to_i})") do
    click_link "delete"
  end
end

When /^I check the (\d+)(?:st|nd|rd|th) message$/ do |pos|
  visit "/user/#{@user.login}/panel"
  click_link "Message Box"
  within("table > tr:nth-child(#{pos.to_i})") do
    check "messages[]"
  end
end

Then /^I should see the message list:$/ do |messages|
  messages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+1}) > td:nth-child(#{j+3})") { |td|
        td.inner_text.chomp.strip.should == cell
      }
    end
  end
end


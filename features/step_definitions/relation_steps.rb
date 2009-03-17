When /^I send a friend invite request$/ do
  #response.body.should =~ /abc/m
  fill_in "message[title]", :with => "hello"
  fill_in "message[body]", :with => "I want add you to my friend"
  click_button "Send"
end

Then /^user (.*) should received a request from (.*)$/ do |receiver, sender|
  recv = User.find_by_login(receiver)
  send = recv.strangers.find_by_login(sender)
  send.nil?.should == false
end

Given /^I am on my request list page$/ do
  @user.login.should == "Jerry"
  visit "/user/#{@user.login}/panel"
  click_link "Friend Box"
end

Given /^the following list request:$/ do |requests|
  requests.hashes.each do |m|
    user = Factory.create :user, :login => m["sender"], :email => "#{m["sender"]}@test.net" unless m["sender"].nil?
    message = Factory.create :message, :title => m["title"], :body => m["body"]
    message.user = user
    message.receivers << @user
    message.change_to_request
    message.save

    @user.strangers << user
    @user.save

    unless m[:status].nil?
      # Add code for initial friend status
    end
  end
end

When /^I check the (\d+)(?:st|nd|rd|th) request$/ do |pos|
  visit "/user/#{@user.login}/panel"
  click_link "Friend Box"
  within("table > tr:nth-child(#{pos.to_i})") do
    check "request_users[]"
  end
end

Then /^I should see the user (.*) list:$/ do |list_type, messages|
  wait_for
  messages.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("div##{list_type}_list > table > tr:nth-child(#{i+1}) > td:nth-child(#{j+2})") { |td|
        td.inner_text.chomp.strip.should =~ /#{cell}/m
      }
    end
  end
end


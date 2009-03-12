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


When /^I am on the articles list page$/ do
  visit '/blog'
end

Given /^I am on the new article page$/ do
  visit 'blog/post'
  response.body.should =~ /New Article/m
end

Given /^the existing articles:$/ do |articles|
  articles.hashes.each do |m|
    if !m["author"].nil? && m["author"].to_s != @user.login
      user = Factory.create :user, :login => m["author"], :email => "#{m["author"]}@test.net" 
    end
    message = Factory.create :message, :title => m["title"], :body => m["body"]
    message.user = user
    message.receivers << @user
    message.message_type = 'blog'
    message.save
  end
end

When /^I change the articles:$/ do |articles|
  articles.hashes.each do |m|
    visit '/blog/manage'
    message = Message.find_by_title(m["origin"])
    message.title = m["title"]
    message.body = m["body"]
    message.save
  end
end

Given /^the following articles:$/ do |articles|
  pending
end

When /^I delete the 3rd articles$/ do
  pending
end

Then /^I should see the following articles:$/ do
  pending
end

Given /^the posted article:$/ do |articles|
  pending
end

When /^I comment the article$/ do
  pending
end

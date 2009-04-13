When /^I goto the forum first page$/ do
  visit topics_path
end

Given /^I am on a topic page named (.*)$/ do |name|
  @topic = Factory.create(:topic, :name => name)
  visit topic_path(@topic)
end

When /^I follow a topic titled (.*)$/ do |title|
  message = Factory.create(:message, :title => title)
  message.message_type = 'topic'
  message.user = Factory.create(:user, :login => 'temp', :email => 'e@ma.il')
  message.topic_id = @topic.id
  message.save
  visit message_path(message)
end


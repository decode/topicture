When /^I am on the articles list page$/ do
  visit '/blog'
end

When /^I am on the article manage page$/ do
  visit '/blog/manage'
  response.body.should =~ /New article/m
  response.body.should =~ /Edit/m
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
    message.user = User.find_by_login(m["author"])
    session[:target_user_id] = message.user.id
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

When /^I view the article$/ do
  @target_user = User.find_by_id(session[:target_user_id])
  puts @target_user.login
  visit "/user/#{@target_user.login}/"
  response.body.should =~ /more.../m
  click_link "more..." 
  response.body.should =~ /Comments/m
end

Given /^I am on gallary index page$/ do
  visit gallaries_path
end

Given /^the existing gallaries:$/ do |gallaries|
  gallaries.hashes.each do |m|
    user = User.find_by_login(m["owner"])
    if user.nil?
      user = Factory.create :user, :login => m["owner"], :email => "#{m["owner"]}@test.net" unless m["owner"].nil?
    end
    gallary = Factory.create :gallary, :name => m["name"]
    gallary.user = user
    gallary.save
  end
end


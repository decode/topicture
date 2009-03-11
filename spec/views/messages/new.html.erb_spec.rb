require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/messages/new.html.erb" do
  include MessagesHelper
  
  before(:each) do
    assigns[:message] = stub_model(Message,
      :new_record? => true,
      :title => "value for title",
      :body => "value for body",
      :follow_id => 1
    )
  end

  it "should render new form" do
    render "/messages/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", messages_path) do
      with_tag("input#message_title[name=?]", "message[title]")
      with_tag("textarea#message_body[name=?]", "message[body]")
      with_tag("input#message_follow_id[name=?]", "message[follow_id]")
    end
  end
end



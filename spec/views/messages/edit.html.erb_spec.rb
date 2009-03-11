require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/messages/edit.html.erb" do
  include MessagesHelper
  
  before(:each) do
    assigns[:message] = @message = stub_model(Message,
      :new_record? => false,
      :title => "value for title",
      :body => "value for body",
      :follow_id => 1
    )
  end

  it "should render edit form" do
    render "/messages/edit.html.erb"
    
    response.should have_tag("form[action=#{message_path(@message)}][method=post]") do
      with_tag('input#message_title[name=?]', "message[title]")
      with_tag('textarea#message_body[name=?]', "message[body]")
      with_tag('input#message_follow_id[name=?]', "message[follow_id]")
    end
  end
end



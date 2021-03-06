require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/messages/index.html.erb" do
  include MessagesHelper
  
  before(:each) do
    assigns[:messages] = [
      stub_model(Message,
        :title => "value for title",
        :body => "value for body",
        :follow_id => 1
      ),
      stub_model(Message,
        :title => "value for title",
        :body => "value for body",
        :follow_id => 1
      )
    ]
  end

  it "should render list of messages" do
    render "/messages/index.html.erb"
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end


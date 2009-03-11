require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/messages/show.html.erb" do
  include MessagesHelper
  before(:each) do
    assigns[:message] = @message = stub_model(Message,
      :title => "value for title",
      :body => "value for body",
      :follow_id => 1
    )
  end

  it "should render attributes in <p>" do
    render "/messages/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ body/)
    response.should have_text(/1/)
  end
end


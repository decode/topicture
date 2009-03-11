require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/show.html.erb" do
  include TopicsHelper
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic,
      :name => "value for name",
      :parent_id => 1,
      :description => "value for description"
    )
  end

  it "should render attributes in <p>" do
    render "/topics/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ description/)
  end
end


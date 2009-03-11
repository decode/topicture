require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/index.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topics] = [
      stub_model(Topic,
        :name => "value for name",
        :parent_id => 1,
        :description => "value for description"
      ),
      stub_model(Topic,
        :name => "value for name",
        :parent_id => 1,
        :description => "value for description"
      )
    ]
  end

  it "should render list of topics" do
    render "/topics/index.html.erb"
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end


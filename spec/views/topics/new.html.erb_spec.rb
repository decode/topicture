require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/new.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = stub_model(Topic,
      :new_record? => true,
      :name => "value for name",
      :parent_id => 1,
      :description => "value for description"
    )
  end

  it "should render new form" do
    render "/topics/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", topics_path) do
      with_tag("input#topic_name[name=?]", "topic[name]")
      with_tag("input#topic_parent_id[name=?]", "topic[parent_id]")
      with_tag("textarea#topic_description[name=?]", "topic[description]")
    end
  end
end



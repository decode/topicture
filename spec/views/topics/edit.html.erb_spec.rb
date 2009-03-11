require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/topics/edit.html.erb" do
  include TopicsHelper
  
  before(:each) do
    assigns[:topic] = @topic = stub_model(Topic,
      :new_record? => false,
      :name => "value for name",
      :parent_id => 1,
      :description => "value for description"
    )
  end

  it "should render edit form" do
    render "/topics/edit.html.erb"
    
    response.should have_tag("form[action=#{topic_path(@topic)}][method=post]") do
      with_tag('input#topic_name[name=?]', "topic[name]")
      with_tag('input#topic_parent_id[name=?]', "topic[parent_id]")
      with_tag('textarea#topic_description[name=?]', "topic[description]")
    end
  end
end



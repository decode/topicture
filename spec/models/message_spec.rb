require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :follow_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
end

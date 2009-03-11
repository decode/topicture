require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TopicsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "topics", :action => "index").should == "/topics"
    end
  
    it "should map #new" do
      route_for(:controller => "topics", :action => "new").should == "/topics/new"
    end
  
    it "should map #show" do
      route_for(:controller => "topics", :action => "show", :id => 1).should == "/topics/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "topics", :action => "edit", :id => 1).should == "/topics/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "topics", :action => "update", :id => 1).should == "/topics/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "topics", :action => "destroy", :id => 1).should == "/topics/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/topics").should == {:controller => "topics", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/topics/new").should == {:controller => "topics", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/topics").should == {:controller => "topics", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/topics/1").should == {:controller => "topics", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/topics/1/edit").should == {:controller => "topics", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/topics/1").should == {:controller => "topics", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/topics/1").should == {:controller => "topics", :action => "destroy", :id => "1"}
    end
  end
end

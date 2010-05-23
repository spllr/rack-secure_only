require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require "rack/secure_only/request"
require 'rack/mock'

describe Rack::Request do
  describe "when rack/secure_only/request is required" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("http://example.com/"))
    end
    
    it "should respond to http?" do
      @req.should respond_to :http?
    end
    
    it "should respond to https?" do
      @req.should respond_to :https?      
    end
    
    it "should respond to use_forwarded_proto?" do
      @req.should respond_to :use_forwarded_proto?      
    end
    
    it "should respond to use_forwarded_proto=" do
      @req.should respond_to :use_forwarded_proto=
    end
    
    it "should respond to use_forwarded_proto" do
      @req.should respond_to :use_forwarded_proto
    end
    
    it "should respond to forwarded_proto" do
      @req.should respond_to :forwarded_proto
    end
  end
  
  describe "use_forwarded_proto defaults" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("http://example.com/"))
    end
    
    it "should use forwarded_proto header (HTTP_X_FORWARDED_PROTO)" do
      @req.should be_use_forwarded_proto
    end
    
    it "should have set use_forwarded_proto to true (HTTP_X_FORWARDED_PROTO)" do
      @req.use_forwarded_proto.should == true
    end
  end
  
  context "with request http://example.com/" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("http://example.com/"))
    end
    
    it "#http? should return true" do
      @req.should be_http
    end
    
    it "#https? should return false" do
      @req.should_not be_https
    end
  end
  
  context "with request https://example.com/" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("https://example.com/"))
    end
    
    it "#http? should return true" do
      @req.should_not be_http
    end
    
    it "#https? should return false" do
      @req.should be_https
    end
  end
end

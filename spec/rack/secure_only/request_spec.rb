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
    
    it "should respond to forwarded_proto" do
      @req.should respond_to :forwarded_proto
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
    
    it "#http? should return false" do
      @req.should_not be_http
    end
    
    it "#https? should return true" do
      @req.should be_https
    end
  end
  
  context "with request http://example.com/ and HTTP_X_FORWARDED_PROTO set to https" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("http://example.com/", { 'HTTP_X_FORWARDED_PROTO' => 'https' }))
    end
    
    it "#http? should return false" do
      @req.should_not be_http
    end
    
    it "#https? should return true" do
      @req.should be_https
    end
    
    context "and use_forwarded_proto set to false" do      
      it "#http? should return true" do
        @req.http?(false).should == true
      end

      it "#https? should return false" do
        @req.https?(false).should == false
      end
    end
  end
  
  context "with request https://example.com/ and HTTP_X_FORWARDED_PROTO set to https" do
    before(:each) do
      @req = Rack::Request.new(Rack::MockRequest.env_for("https://example.com/", { 'HTTP_X_FORWARDED_PROTO' => 'https' }))
    end
    
    it "#http? should return false" do
      @req.should_not be_http
    end
    
    it "#https? should return true" do
      @req.should be_https
    end
    
    context "and use_forwarded_proto set to false" do      
      it "#http? should return false" do
        @req.http?(false).should == false
      end

      it "#https? should return true" do
        @req.https?(false).should == true
      end
    end
  end
end

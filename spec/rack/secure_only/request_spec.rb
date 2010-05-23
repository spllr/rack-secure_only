require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

require "rack/secure_only/request"
require 'rack/mock'

describe Rack::Request do
  describe "when rack/secure_only/request is included" do
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
  end
end

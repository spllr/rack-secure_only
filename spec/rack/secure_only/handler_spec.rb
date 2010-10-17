require File.expand_path('../../../spec_helper', __FILE__)

require "rack/secure_only/handler"

describe Rack::SecureOnly::Handler do
  def make_env(verb='GET', uri='/', opts={})
    opts[:method] = verb
    Rack::MockRequest.env_for(uri, opts)
  end
  
  describe "options" do
    context "defaults" do
      subject { Rack::SecureOnly::Handler.new({}) }
      its(:secure) { should == true }
      its(:secure?) { should == true }
      its(:status_code) { should == 301 }
      its(:redirect_to) { should == nil }
      its(:use_http_x_forwarded_proto) { should == true }
    end
    
    context "custom" do
      let(:options) {
        {
          :secure => false, 
          :status_code => 302, 
          :redirect_to => '/login', 
          :use_http_x_forwarded_proto => false
        }
      }
      subject { Rack::SecureOnly::Handler.new({}, options) }
      its(:secure) { should == options[:secure] }
      its(:secure?) { should == options[:secure] }
      its(:status_code) { should == options[:status_code] }
      its(:redirect_to) { should == options[:redirect_to] }
      its(:use_http_x_forwarded_proto) { should == options[:use_http_x_forwarded_proto] }
    end
  end
  
  context "env handling" do
    it "should accept an env hash" do
      lambda { Rack::SecureOnly::Handler.new(make_env) }.should_not raise_error
    end
    
    it "should accept a Rack::Request" do
      lambda { Rack::SecureOnly::Handler.new(Rack::Request.new(make_env)) }.should_not raise_error
    end
  end
  
  describe "#redirect?" do
    context "when scheme is http and secure is true" do
      subject { Rack::SecureOnly::Handler.new(make_env(:get, 'http://example.com/'))}
      its(:https?) { should == false }
      its(:http?) { should == true }
      its(:redirect?) { should == true }
    end
    
    context "when scheme is https and secure is true" do
      subject { Rack::SecureOnly::Handler.new(make_env(:get, 'https://example.com/'))}
      its(:https?) { should == true }
      its(:http?) { should == false }
      its(:redirect?) { should == false }
    end
  end  
end

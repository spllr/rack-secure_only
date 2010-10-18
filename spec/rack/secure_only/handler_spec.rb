require File.expand_path('../../../spec_helper', __FILE__)

require "rack/secure_only/handler"

shared_examples_for "insecure env" do
  its(:https?) { should == false }
  its(:http?) { should == true }
end

shared_examples_for "secure env" do
  its(:https?) { should == true }
  its(:http?) { should == false }
end

shared_examples_for "redirecting" do
  its(:redirect?) { should == true }
  its(:location) { should_not be_nil }
end

shared_examples_for "not redirecting" do
  its(:redirect?) { should == false }
end

describe Rack::SecureOnly::Handler do
  def make_env(verb='GET', uri='/', opts={})
    opts[:method] = verb
    @env = Rack::MockRequest.env_for(uri, opts)
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
  
  describe Rack::SecureOnly::Handler do
    let(:options) { Hash.new }
    subject { Rack::SecureOnly::Handler.new(@env, options) }
    
    context "when secure is true" do
      let(:options) { { :secure => true } }
      context "and scheme is http" do
        before { make_env(:get, 'http://www.example.com/') }
        it_should_behave_like "insecure env"
        it_should_behave_like "redirecting"
        its(:location) { should == 'https://www.example.com/' }
      end

      context "and scheme is https" do
        before { make_env(:get, 'https://www.example.com/') }
        it_should_behave_like "secure env"
        it_should_behave_like "not redirecting"
        its(:location) { should == 'https://www.example.com/' }
      end

      context "and scheme is https and X-Forwarded-Proto is set to https" do
        before { make_env(:get, 'https://www.example.com/', { 'HTTP_X_FORWARDED_PROTO' => 'https' }) }
        it_should_behave_like "secure env"
        it_should_behave_like "not redirecting"
        its(:location) { should == 'https://www.example.com/' }
      end

      context "and scheme is http and X-Forwarded-Proto is set to https" do
        before { make_env(:get, 'https://www.example.com/', { 'HTTP_X_FORWARDED_PROTO' => 'https' }) }
        it_should_behave_like "secure env"
        it_should_behave_like "not redirecting"
        its(:location) { should == 'https://www.example.com/' }
      end
    end
    
    context "when secure is false" do
      let(:options) { { :secure => false } }
      context "and scheme is http" do
        before { make_env(:get, 'http://www.example.com/') }
        it_should_behave_like "insecure env"
        it_should_behave_like "not redirecting"
        its(:location) { should == 'http://www.example.com/' }
      end

      context "and scheme is https" do
        before { make_env(:get, 'https://www.example.com/') }
        it_should_behave_like "secure env"
        it_should_behave_like "redirecting"
        its(:location) { should == 'http://www.example.com/' }
      end

      context "and scheme is https and X-Forwarded-Proto is set to https" do
        before { make_env(:get, 'https://www.example.com/', { 'HTTP_X_FORWARDED_PROTO' => 'https' }) }
        it_should_behave_like "secure env"
        it_should_behave_like "redirecting"
        its(:location) { should == 'http://www.example.com/' }
      end

      context "and scheme is http and X-Forwarded-Proto is set to https" do
        before { make_env(:get, 'https://www.example.com/', { 'HTTP_X_FORWARDED_PROTO' => 'https' }) }
        it_should_behave_like "secure env"
        it_should_behave_like "redirecting"
        its(:location) { should == 'http://www.example.com/' }
      end
    end
    
    context "when :redirect_to is set" do
      let(:options) { { :redirect_to => 'https://www.example.com/login' } }
      context "and redirecting" do
        before { Rack::SecureOnly::Handler.any_instance.stubs(:redirect?).returns(true) }
        before { make_env(:get, 'http://www.example.com/') }
        its(:location) { should == options[:redirect_to] }
      end
      
      context "and not redirecting" do
        before { Rack::SecureOnly::Handler.any_instance.stubs(:redirect?).returns(false) }
        before { make_env(:get, 'https://www.example.com/') }
        its(:location) { should_not == options[:redirect_to] }
      end
    end
  end
end

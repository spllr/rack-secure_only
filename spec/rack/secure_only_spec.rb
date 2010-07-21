require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rack::SecureOnly do
  
  def app
    Rack::Builder.new do      
      map '/secure' do
        use Rack::SecureOnly
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
      
      map '/notsecure' do
        use Rack::SecureOnly, :secure => false
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["NON SECURE APP"]] }
      end
    end
  end
  
  describe "Enforcing https" do
    before(:each) do
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('https://www.example.com/secure')
    end

    describe "when requesting https://www.example.com/secure" do
      it "should pass" do
        @response.body.should == "SECURE APP"
      end

      it "should set status to 200 ok" do
        @response.status.should == 200
      end

      it "should not set a location header" do
        @response.location.should be_nil
      end

      describe "with HTTP_X_FORWARDED_PROTO header set to https (like with heroku ssl)" do
        before(:each) do
          @response = @request.get('http://www.example.com/secure', { 'HTTP_X_FORWARDED_PROTO' => 'https' })
        end

        it "should do no redirect" do
          @response.location.should be_nil
        end
      end

    end

    describe "when requesting http://www.example.com/secure" do
      before(:each) do
        @response = @request.get('http://www.example.com/secure')
      end
      it "should respond with status 301 redirect" do
        @response.status.should == 301
      end

      it "should set location to https://www.example.com/secure" do
        @response.location.should == "https://www.example.com/secure"
      end

      it "should set a content type" do
        @response.content_type.should == 'text/plain'
      end

      describe "following redirect" do
        before(:each) do
          @redirect_response = @request.get(@response.location)
        end

        it "should pass" do
          @redirect_response.body.should == "SECURE APP"
        end

        it "should respond 200 ok" do
          @redirect_response.status.should == 200
        end
      end
    end
  end

  describe "Enforcing http" do
    before(:each) do
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('https://www.example.com/notsecure')
    end

    describe "when requesting https://www.example.com/notsecure" do
      
      it "should respond with status 301 redirect" do
        @response.status.should == 301
      end

      it "should set location to http://www.example.com/notsecure" do
        @response.location.should == "http://www.example.com/notsecure"
      end

      it "should set a content type" do
        @response.content_type.should == 'text/plain'
      end

      describe "and following redirect" do
        before(:each) do
          @redirect_response = @request.get(@response.location)
        end

        it "should pass" do
          @redirect_response.body.should == "NON SECURE APP"
        end

        it "should respond 200 ok" do
          @redirect_response.status.should == 200
        end
      end
    end

    describe "when requesting http://www.example.com/notsecure" do
      before(:each) do
        @response = @request.get('http://www.example.com/notsecure')
      end
      
      it "should pass" do
        @response.body.should == "NON SECURE APP"
      end

      it "should set status to 200 ok" do
        @response.status.should == 200
      end

      it "should not set a location header" do
        @response.location.should be_nil
      end

      describe "with HTTP_X_FORWARDED_PROTO header set to https (like with heroku ssl)" do
        before(:each) do
          @response = @request.get('http://www.example.com/notsecure', { 'HTTP_X_FORWARDED_PROTO' => 'https' })
        end

        it "should do no redirect" do
          @response.location.should == "http://www.example.com/notsecure"
        end
      end
    end
  end
  
  describe "configuration" do
    it "should use :status_code if provided" do
      app = Rack::Builder.new do      
        use Rack::SecureOnly, :status_code => 307
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('http://www.example.com/')
      
      @response.status.should == 307
    end
    
    it "should use :redirect_to if provided" do
      app = Rack::Builder.new do      
        use Rack::SecureOnly, :redirect_to => 'https://www.example.com/login'
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('http://www.example.com/')
      
      @response.location.should == 'https://www.example.com/login'
    end
    
    it "should use :redirect_to if provided with :secure => false" do
      app = Rack::Builder.new do      
        use Rack::SecureOnly, :redirect_to => 'https://www.example.com/login', :secure => false
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('https://www.example.com/')
      
      @response.location.should == 'http://www.example.com/login'
    end
    
    it "should not check HTTP_X_FORWARDED_PROTO if :use_http_x_forwarded_proto is set to false" do
      app = Rack::Builder.new do      
        use Rack::SecureOnly, :use_http_x_forwarded_proto => false
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
      @request  = Rack::MockRequest.new(app)
      @response = @request.get('http://www.example.com/',  { 'HTTP_X_FORWARDED_PROTO' => 'https' })
      
      @response.location.should == "https://www.example.com/"      
    end
  end
end

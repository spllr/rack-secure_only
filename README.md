# rack-secure_only

SecureOnly will redirect to https if the request is on http.

When passed :secure => false it will do the opposite and redirect https to http.

The check if the current request is on https includes checking the HTTP_X_FORWARDED_PROTO header.
This means the redirect will also work on heroku.com

This can be disabled by setting the :use_http_x_forwarded_proto option to false.

It is currently only tested on ruby 1.9

## Installation

    sudo gem install rack-secure_only

## Usage

    require 'rack-secure_only'

    app = Rack::Builder.new do      
      map '/secure' do
        use Rack::SecureOnly
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end

      map '/notsecure' do
        use Rack::SecureOnly, :secure => false
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["NON SECURE APP"]] }
      end

      map '/secure_without_http_x_forwarded_proto_check' do
        use Rack::SecureOnly, :use_http_x_forwarded_proto => false
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end

      map '/secure_with_fixed_redirect_url' do
        use Rack::SecureOnly, :redirect_to => "https://my.site.org/login"
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
  
      map '/secure_with_an_if_condition' do
        use Rack::SecureOnly, :if => ENV['RACK_ENV'] == 'production'
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["SECURE APP"]] }
      end
  
      map '/secure_with_an_if_condition_block' do
        use Rack::SecureOnly, :if => Proc.new { |request| request.params.key?('secure_thing') }
        run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ["APP"]] }
      end
    end

    run app
    
This will redirect all requests to /secure to https and all requests to /notsecure to http.

### Rack::Request

When rack-secure_only is required the Rack::Request will be extended with some convenience methods
to determine if the current request is http or https

    require 'rack-secure_only'

    run lambda { |env| 
      req = Request.new(env)
      
      res_body = ""
      
      if req.https?
        res_body = "You just made a request on https"
      elsif req.http?
        res_body = "You just made a request on http"
      elsif req.https?(false) # do not check the HTTP_X_FORWARDED_PROTO header
        res_body = "You just made a request on a url with scheme https"  
      elsif req.http?(false) # do not check the HTTP_X_FORWARDED_PROTO header
        res_body = "You just made a request on a url with scheme http, I did not check the HTTP_X_FORWARDED_PROTO header"
      end
      
      res_body << " and the HTTP_X_FORWARDED_PROTO header was set to" + req.forwarded_proto
      
      [200, { 'Content-Type' => 'text/plain' }, res_body]
    }

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Klaas Speller. See LICENSE for details.

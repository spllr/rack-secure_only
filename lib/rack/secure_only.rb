require "rack"
require "rack/secure_only/request"

module Rack
  
  # SecureOnly will redirect to https if the request is on http.
  # 
  # When passed :secure => false it will do the opposite and redirect https to http
  #
  # The check if the current request is on https includes checking 
  # the HTTP_X_FORWARDED_PROTO header.
  #
  # This means the redirect will also work on heroku.com
  #
  # @param [Hash] opts options for redirect rules
  # @option opts [Boolean] :secure If set to false will redirect https to http, defaults to true
  # @option opts [Fixnum]  :status_code Status code to redirect with, defaults to 301
  # @option opts [Boolean] :use_http_x_forwarded_proto When set to false will not check for HTTP_X_FORWARDED_PROTO header
  # @option opts [String]  :redirect_to When set will use the provided url to redirect to
  #
  class SecureOnly
    def initialize(app, opts={})
      @app    = app
      @opts    = { 
                  :secure => true, 
                  :status_code => 301, 
                  :redirect_to => nil, 
                  :use_http_x_forwarded_proto => true 
                  }.merge(opts)      
    end
    
    def call(env)
      should_redirect, to_path = redirect?(env)
      if should_redirect
        return [@opts[:status_code], { 'Content-Type'  => 'text/plain', 'Location' => to_path }, ["Redirect"]]
      end
      @app.call(env)
    end
    
    # Boolean accesor for :secure
    #  
    def secure?
      !!@opts[:secure]
    end

    # Inversed boolean accesor for :secure
    #      
    def not_secure?
      !secure?
    end
    
    # Returns false if the current request should
    # not be handled by the middleware
    # 
    def handle?(req)
      if @opts.key?(:if)
        cond = @opts[:if]
        cond = cond.call(req) if cond.respond_to?(:call)
        return cond
      end
      true
    end
    
    protected
    
    def redirect?(env)
      req = Request.new(env)
      url = @opts[:redirect_to] || req.url
      
      # Determine if the middleware should handle this request
      return [false, req.url] unless handle?(req)
      
      # Determine http(s) behavior
      if secure? && req.http?(@opts[:use_http_x_forwarded_proto])
        return [true, url.gsub(/^http:/,'https:')]
      elsif not_secure? && req.https?(@opts[:use_http_x_forwarded_proto])
        return [true, url.gsub(/^https:/,'http:')]
      else
        return [false, req.url]
      end
    end
  end
end
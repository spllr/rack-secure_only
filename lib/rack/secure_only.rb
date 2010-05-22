require "rack"

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
  class SecureOnly
    def initialize(app, opts={})
      opts    = { :secure => true, :status_code => 301, :redirect_to => nil, :use_http_x_forwarded_proto => true }.merge(opts)
      @app    = app
      
      @secure               = opts[:secure]
      @redirect_status_code = opts[:status_code]
      @redirect_to          = opts[:redirect_to]
      @use_http_x_forward  = !!opts[:use_http_x_forwarded_proto]
    end
    
    def call(env)
      should_redirect, to_path = redirect?(env)
      return [@redirect_status_code, { 'Content-Type'  => 'text/plain', 'Location' => to_path }, ["Redirect"]] if should_redirect
      @app.call(env)
    end
    
    # Returns true if the current url scheme is http
    # and the HTTP_X_FORWARDED_PROTO header is not set to https
    # 
    def on_http?(env)
      ( env['rack.url_scheme'] == 'http' && ( use_x_forward? ? env['HTTP_X_FORWARDED_PROTO'] != 'https' : true ) )
    end
    
    # Returns true if the current url scheme is https or 
    # the HTTP_X_FORWARDED_PROTO header is set to https
    # 
    def on_https?(env)
      ( env['rack.url_scheme'] == 'https' || ( use_x_forward? ? env['HTTP_X_FORWARDED_PROTO'] == 'https' : false ) )
    end
    
    # Boolean accesor for :secure
    #  
    def secure?
      !!@secure
    end

    # Inversed boolean accesor for :secure
    #      
    def not_secure?
      !secure?
    end
    
    protected
    
    def redirect?(env)
      req = Request.new(env)
      url = @redirect_to || req.url
      if secure? && on_http?(env)
        return [true, url.gsub(/^http:/,'https:')]
      elsif not_secure? && on_https?(env)
        return [true, url.gsub(/^https:/,'http:')]
      else
        return [false, req.url]
      end
    end
    
    def use_x_forward?
      @use_http_x_forward
    end
  end
end
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
      opts    = { :secure => true }.merge(opts)
      @app    = app
      @secure = opts[:secure]
    end
    
    def call(env)
      should_redirect, to_path = redirect?(env)
      return [307, { 'Content-Type'  => 'text/plain', 'Location' => to_path }, ["Redirect"]] if should_redirect
      @app.call(env)
    end
    
    # Returns true if the current url scheme is http
    # and the HTTP_X_FORWARDED_PROTO header is not set to https
    # 
    def on_http?(env)
      ( env['rack.url_scheme'] == 'http' && env['HTTP_X_FORWARDED_PROTO'] != 'https')
    end
    
    # Returns true if the current url scheme is https or 
    # the HTTP_X_FORWARDED_PROTO header is set to https
    # 
    def on_https?(env)
      ( env['rack.url_scheme'] == 'https' || env['HTTP_X_FORWARDED_PROTO'] == 'https')
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
      if secure? && on_http?(env)
        return [true, req.url.gsub(/^http:/,'https:')]
      elsif not_secure? && on_https?(env)
        return [true, req.url.gsub(/^https:/,'http:')]
      else
        return [false, req.url]
      end
    end
  end
end
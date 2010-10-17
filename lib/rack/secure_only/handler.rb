module Rack
  class SecureOnly
    class Handler
      attr_accessor :secure, :status_code, :redirect_to, :use_http_x_forwarded_proto
      alias_method :secure?, :secure

      def initialize(env, opts={})
        opts = { 
          :secure => true, :status_code => 301, :redirect_to => nil, :use_http_x_forwarded_proto => true
        }.merge(opts)
        
        @request     = env.is_a?(Rack::Request) ? env : Rack::Request.new(env)
        @secure      = opts[:secure]
        @status_code = opts[:status_code]
        @redirect_to = opts[:redirect_to]
        @use_http_x_forwarded_proto = opts[:use_http_x_forwarded_proto]
      end
      
      def https?
        if @use_http_x_forwarded_proto
          @request.scheme == 'https' || @request['HTTP_X_FORWARDED_PROTO'] == 'https'
        else
          @request.scheme == 'https'
        end
      end
      
      def http?
        if @use_http_x_forwarded_proto
          @request.scheme == 'http' && @request['HTTP_X_FORWARDED_PROTO'] != 'https'
        else
          @request.scheme == 'http'
        end
      end
      
      def redirect?
        if http? && secure?
          true
        elsif https? && secure?
          false
        end
      end
    end
  end
end
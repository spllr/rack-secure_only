require "rack/request"

module Rack
  
  # The secure_only extension add some convenience methods
  # to determine if the request is a http or a https request
  #
  class Request 
   
    # Returns true if the current url scheme is http
    # and the HTTP_X_FORWARDED_PROTO header is not set to https
    #
    def http?(use_forwarded_proto=true)
      if use_forwarded_proto
        scheme == 'http' && forwarded_proto != 'https'
      else
        scheme == 'http'
      end
    end

    # Returns true if the current url scheme is https or 
    # the HTTP_X_FORWARDED_PROTO header is set to https
    #    
    def https?(use_forwarded_proto=true)
      if use_forwarded_proto
        scheme == 'https' || forwarded_proto == 'https'
      else
        scheme == 'https'
      end
    end
    
    # @return [String] the value of the HTTP_X_FORWARDED_PROTO header
    #
    def forwarded_proto
      @env['HTTP_X_FORWARDED_PROTO']
    end
  end
end

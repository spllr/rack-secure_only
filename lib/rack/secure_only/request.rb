require "rack/request"

module Rack
  class Request    
    def http?(use_forwarded_proto=true)
      if use_forwarded_proto
        scheme == 'http' && forwarded_proto != 'https'
      else
        scheme == 'http'
      end
    end
    
    def https?(use_forwarded_proto=true)
      if use_forwarded_proto
        scheme == 'https' || forwarded_proto == 'https'
      else
        scheme == 'https'
      end
    end
        
    def forwarded_proto
      @env['HTTP_X_FORWARDED_PROTO']
    end
  end
end

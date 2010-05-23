require "rack/request"

module Rack
  class Request
    def http?
      if use_forwarded_proto?
        scheme == 'http' && forwarded_proto != 'https'
      else
        scheme == 'http'
      end
    end
    
    def https?
      if use_forwarded_proto?
        scheme == 'https' || forwarded_proto == 'https'
      else
        scheme == 'https'
      end
    end
    
    def use_forwarded_proto=(flag)

    end
    
    def use_forwarded_proto
      true
    end
    
    def use_forwarded_proto?
      true      
    end
    
    def forwarded_proto
      @env['HTTP_X_FORWARDED_PROTO']
    end
  end
end

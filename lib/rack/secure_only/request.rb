require "rack/request"

module Rack
  class Request
    def http?
      scheme == 'http'
    end
    
    def https?
      scheme == 'https'
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

    end
  end
end

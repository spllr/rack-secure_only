require "rack/request"

module Rack
  class Request
    def http?
      true
    end
    
    def https?
      false
    end
    
    def use_forwarded_proto=(flag)

    end
    
    def use_forwarded_proto
      true
    end
    
    def use_forwarded_proto?
      true      
    end
  end
end

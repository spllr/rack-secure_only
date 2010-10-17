$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/secure_only'
require 'rspec'

require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :mocha
end

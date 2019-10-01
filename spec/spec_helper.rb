require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
  config.platform = 'ubuntu'
  config.version = '18.04'
end

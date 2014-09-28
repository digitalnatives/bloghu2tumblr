require 'factory_girl'

RSpec.configure do |config|
  FactoryGirl.reload
  config.include FactoryGirl::Syntax::Methods
end

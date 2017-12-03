# -*- coding: utf-8 -*-

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'ndenv' }

require 'chef/application'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '16.04'
end

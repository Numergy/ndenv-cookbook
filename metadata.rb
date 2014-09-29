name 'ndenv'
maintainer 'Antoine Rouyer'
maintainer_email 'antoine.rouyer@numergy.com'
license 'Apache 2.0'
description 'Installs/Configures ndenv'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.1'

recipe 'ndenv', 'Installs and configures ndenv and node-build.'
recipe 'ndenv::install', 'Install specified versions of node.js.'

%w(apt build-essential git).each do |cb|
  depends cb
end

%w(ubuntu debian).each do |os|
  supports os
end

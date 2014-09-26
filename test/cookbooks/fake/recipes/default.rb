# -*- coding: utf-8 -*-
ndenv_npm 'v0.10.20-bower' do
  package_name 'bower'
  node_version 'v0.10.20'
end

ndenv_npm 'v0.10.26-bower' do
  package_name 'bower'
  node_version 'v0.10.26'
  version '1.3.10'
end

ndenv_npm 'v0.10.26-grunt' do
  source 'https://github.com/gruntjs/grunt/archive/v0.4.5.tar.gz'
  node_version 'v0.10.26'
end
